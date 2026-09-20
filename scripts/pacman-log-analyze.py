#!/usr/bin/env python3
"""
pacman-log-analyze — analyze your Arch Linux package history from /var/log/pacman.log

Counts installed / reinstalled / upgraded / downgraded / removed packages per year,
ever since your first log entry (usually your Arch install date), and optionally
renders charts with gnuplot.

Requires only Python 3 (stdlib). gnuplot is optional, for --plot.

Examples:
    pacman-log-analyze.py
    pacman-log-analyze.py --format markdown
    pacman-log-analyze.py --format csv --output my-stats.csv --plot ./charts
    pacman-log-analyze.py ~/backup/pacman.log --json
"""

import argparse
import csv
import json
import re
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path

DEFAULT_LOG = "/var/log/pacman.log"

METRICS = ["installed", "reinstalled", "upgraded", "downgraded", "removed"]

# Log lines come in three historical formats:
#   [2019-06-22T13:14:15+0000] [ALPM] upgraded pacman (4.0.3-7 -> 4.1.0-2)  # current
#   [2013-04-07 16:56]        [PACMAN] upgraded pacman (...)                # mid-era
#   [2010-01-01 00:00]         installed foo (1.2-3)                        # oldest
# The current format uses a 'T' separator, seconds, and a timezone offset (+0000).
# Older logs omit the timezone and/or seconds. The timezone is intentionally
# ignored here: we only need the year when grouping, not the local offset.
LOG_LINE_RE = re.compile(
    r"^\[(?P<date>\d{4}-\d{2}-\d{2})[ T]"
    r"(?P<time>\d{1,2}:\d{2}(?::\d{2})?)"
    r"(?:Z|[+-]\d{2}:?\d{2})?"
    r"\]\s?(?P<msg>.*)$"
)
PREFIX_RE = re.compile(r"^\[(ALPM(?:-SCRIPTLET)?|PACMAN)\]\s+")

EVENT_RES = {
    "installed":   re.compile(r"^installed\s+(\S+)\s+\((.*)\)$"),
    "reinstalled": re.compile(r"^reinstalled\s+(\S+)\s+\((.*)\)$"),
    "upgraded":    re.compile(r"^upgraded\s+(\S+)\s+\((.*)\s+->\s+(.*)\)$"),
    "downgraded":  re.compile(r"^downgraded\s+(\S+)\s+\((.*)\s+->\s+(.*)\)$"),
    "removed":     re.compile(r"^removed\s+(\S+)\s+\((.*)\)$"),
}

TRANSACTION_RE = re.compile(r"^transaction (started|completed|failed|interrupted)")
SYNC_RE = re.compile(r"^synchronizing package lists")
COMMAND_RE = re.compile(r"^Running '(.*)'")
HOOK_RUN_RE = re.compile(r"^running '(.*)'")
SCRIPTLET_CLUE_RE = re.compile(
    r"^(->|==>|::|>>>|gpg:)|Generating locales|UTF-8\.\.\. done$|^Generation complete"
)
# Strip ANSI/SGR colors (pacman 7+ colors hook/scriptlet output) before matching.
ANSI_RE = re.compile(r"\x1b\[[0-9;]*m|\x1b\([A-Za-z]")

def strip_ansi(text):
    return ANSI_RE.sub("", text)


def parse_log(lines, skip_failed_transactions=False):
    """Parse pacman.log lines and return (per_year, summary)."""
    per_year = {}
    first_ts = None
    last_ts = None
    # State machine over ALPM transactions. Events inside a transaction are
    # buffered and only committed when the transaction *completes*, so a
    # transaction that fails can have its packages dropped with --skip-failed.
    pending = []  # list of (year, metric) awaiting a successful commit
    in_transaction = False
    # these two nested funcs close over per_year
    def commit(items):
        for y, metric in items:
            per_year[y][metric] += 1

    summary = {
        "database_syncs": 0,
        "pacman_commands": 0,
        "starting_upgrades": 0,
        "hook_runs": 0,
        "transactions": 0,
        "failed_transactions": 0,
        "warnings": 0,
        "scriptlet_output": 0,
        "unparsed_lines": 0,
        "skipped_in_failed_transactions": None,  # set when the flag is on
    }
    skipped_in_failed = 0

    def record(year, metric):
        nonlocal pending
        if in_transaction:
            pending.append((year, metric))
        else:
            per_year[year][metric] += 1

    for raw in lines:
        m = LOG_LINE_RE.match(raw)
        if not m:
            continue
        date_s, time_s, msg = m.group("date"), m.group("time"), m.group("msg")
        # Seconds may or may not be present depending on the log era.
        fmt = "%Y-%m-%d %H:%M:%S" if time_s.count(":") == 2 else "%Y-%m-%d %H:%M"
        ts = datetime.strptime(f"{date_s} {time_s}", fmt)
        if first_ts is None:
            first_ts = ts
        last_ts = ts
        year = ts.year
        per_year.setdefault(year, {metric: 0 for metric in METRICS})

        raw_msg = m.group("msg")
        # Remember whether this line is ALPM-SCRIPTLET output before we strip
        # the prefix, so leftover continuation lines can be classified cleanly.
        is_scriptlet = PREFIX_RE.match(raw_msg) is not None and (
            PREFIX_RE.match(raw_msg).group(1) == "ALPM-SCRIPTLET"
        )
        msg = strip_ansi(PREFIX_RE.sub("", raw_msg.strip()))

        tm = TRANSACTION_RE.match(msg)
        if tm:
            state = tm.group(1)
            if state == "started":
                in_transaction, pending = True, []
                summary["transactions"] += 1
            elif state in ("failed", "interrupted"):
                summary["failed_transactions"] += 1
                if skip_failed_transactions:
                    skipped_in_failed += len(pending)
                    pending = []
                else:
                    commit(pending)
                    pending = []
                in_transaction = False
            elif state == "completed":
                commit(pending)
                pending = []
                in_transaction = False
            continue

        for metric, rx in EVENT_RES.items():
            if rx.match(msg):
                record(year, metric)
                break
        else:
            if SYNC_RE.match(msg):
                summary["database_syncs"] += 1
            elif COMMAND_RE.match(msg):
                summary["pacman_commands"] += 1
            elif HOOK_RUN_RE.match(msg):
                summary["hook_runs"] += 1
            elif msg.startswith("starting full system upgrade"):
                summary["starting_upgrades"] += 1
            elif msg.startswith("warning"):
                summary["warnings"] += 1
            elif is_scriptlet or msg.startswith("[ALPM") or SCRIPTLET_CLUE_RE.match(msg):
                summary["scriptlet_output"] += 1
            else:
                summary["unparsed_lines"] += 1

    # If the log was truncated mid-transaction, don't lose the buffered events.
    if pending:
        commit(pending)

    if skip_failed_transactions:
        summary["skipped_in_failed_transactions"] = skipped_in_failed

    # Fill in empty years between first and last activity so charts don't skip gaps
    if per_year:
        for year in range(min(per_year), max(per_year) + 1):
            per_year.setdefault(year, {metric: 0 for metric in METRICS})

    summary["install_date"] = first_ts.strftime("%Y-%m-%d %H:%M") if first_ts else None
    summary["last_activity"] = last_ts.strftime("%Y-%m-%d %H:%M") if last_ts else None
    summary["years_tracked"] = (max(per_year) - min(per_year) + 1) if per_year else 0
    return per_year, summary


def currently_installed_packages():
    """Return the number of currently installed packages, or None if pacman is unavailable."""
    pacman = shutil.which("pacman")
    if not pacman:
        return None
    try:
        out = subprocess.run(
            [pacman, "-Q"], capture_output=True, text=True, check=True
        ).stdout
        return sum(1 for _ in out.splitlines())
    except subprocess.SubprocessError:
        return None


def totals(per_year):
    return {
        metric: sum(year[metric] for year in per_year.values()) for metric in METRICS
    }


def render_csv(per_year, totals_, sep=","):
    out = []
    out.append(sep.join(["Year", *[m.capitalize() for m in METRICS]]))
    for year in sorted(per_year):
        out.append(sep.join([str(year), *[str(per_year[year][m]) for m in METRICS]]))
    out.append(sep.join(["Total", *[str(totals_[m]) for m in METRICS]]))
    return "\n".join(out) + "\n"


def render_markdown(per_year, totals_):
    out = []
    out.append("| Year | " + " | ".join(m.capitalize() for m in METRICS) + " |")
    out.append("|" + "---|" * (len(METRICS) + 1))
    for year in sorted(per_year):
        out.append(
            f"| {year} | " + " | ".join(str(per_year[year][m]) for m in METRICS) + " |"
        )
    out.append("| **Total** | " + " | ".join(f"**{totals_[m]}**" for m in METRICS) + " |")
    return "\n".join(out) + "\n"


def render_json(per_year, totals_, summary, installed_now):
    return json.dumps(
        {
            "summary": {**summary, "currently_installed_packages": installed_now},
            "totals": totals_,
            "per_year": {str(y): per_year[y] for y in sorted(per_year)},
        },
        indent=2,
    ) + "\n"


def render_html(per_year, totals_, summary, installed_now, installed_now_pkgs):
    colors = {
        "installed": "#4CAF50",
        "reinstalled": "#FFC107",
        "upgraded": "#2196F3",
        "downgraded": "#FF5722",
        "removed": "#F44336",
    }
    lines = []
    lines.append("<!DOCTYPE html>")
    lines.append("<html lang='en'>")
    lines.append("<head>")
    lines.append("<meta charset='UTF-8'>")
    lines.append("<title>Pacman Package History</title>")
    lines.append("<style>")
    lines.append("body { font-family: Arial, sans-serif; max-width: 800px; margin: 40px auto; background: #f8f9fa; color: #333; }")
    lines.append("h1 { text-align: center; color: #333; margin-bottom: 20px; }")
    lines.append("h2 { color: #555; border-bottom: 2px solid #eee; padding-bottom: 10px; }")
    lines.append(".container { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }")
    lines.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }")
    lines.append("th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }")
    lines.append("th { background: #f0f0f0; }")
    lines.append(".metric { min-width: 120px; }")
    lines.append(".total { font-weight: bold; background: #e9e9e9; }")
    lines.append("emoji { font-size: 1.2em; }")
    lines.append("</style>")
    lines.append("</head>")
    lines.append("<body>")
    lines.append("<h1>📦 Pacman Package History</h1>")
    lines.append("<div class='container'>")
    lines.append("<h2>📊 Summary</h2>")
    lines.append("<p>Arch install date: " + (summary.get('install_date') or 'Unknown') + "</p>")
    lines.append("<p>Last activity: " + (summary.get('last_activity') or 'Unknown') + "</p>")
    lines.append("<p>Currently installed packages: " + (str(installed_now_pkgs) if installed_now_pkgs is not None else 'Unknown') + "</p>")
    lines.append("<p>Pacman commands: " + str(summary.get('pacman_commands', 0)) + " (" + str(summary.get('database_syncs', 0)) + " database syncs, " + str(summary.get('failed_transactions', 0)) + " failed transactions)</p>")
    lines.append("<p>Hook/scriptlet: " + str(summary.get('hook_runs', 0)) + " hook runs + " + str(summary.get('scriptlet_output', 0)) + " scriptlet output lines (" + str(summary.get('unparsed_lines', 0)) + " unparsed)</p>")
    lines.append("</div>")
    lines.append("<div class='container'>")
    lines.append("<h2>📅 Yearly Breakdown</h2>")
    lines.append("<table>")
    lines.append("<tr>")
    lines.append("<th>Year</th>")
    for m in ["installed", "reinstalled", "upgraded", "downgraded", "removed"]:
        lines.append("<th>" + m.capitalize() + "</th>")
    lines.append("<th>Total</th>")
    lines.append("</tr>")
    for year in sorted(per_year):
        lines.append("<tr>")
        lines.append("<td>" + str(year) + "</td>")
        total_year = 0
        for m in METRICS:
            val = per_year[year][m]
            total_year += val
            clr = colors.get(m, "#666")
            lines.append("<td style='color:" + clr + "; font-weight:bold;'>" + str(val) + "</td>")
        lines.append("<td class='total'>" + str(total_year) + "</td>")
        lines.append("</tr>")
    lines.append("<tr class='total'>")
    lines.append("<td><strong>Total</strong></td>")
    for m in METRICS:
        total_m = sum(y[m] for y in per_year.values())
        clr = colors.get(m, "#666")
        lines.append("<td style='color:" + clr + "; font-weight:bold;'><strong>" + str(total_m) + "</strong></td>")
    lines.append("<td class='total'><strong>" + str(totals_['installed'] + totals_['reinstalled'] + totals_['upgraded'] + totals_['downgraded'] + totals_['removed']) + "</strong></td>")
    lines.append("</tr>")
    lines.append("</table>")
    lines.append("</div>")
    lines.append("<div class='container' style='margin-top:40px;'>")
    lines.append("<p style='text-align:center; color:#666; font-size:0.9em;'>Generated by pacman-log-analyze • MIT License</p>")
    lines.append("</div>")
    lines.append("</body>")
    lines.append("</html>")
    return "\n".join(lines)


def write_plot(output_dir, per_year):
    """Write a CSV + gnuplot script into output_dir and render an SVG if gnuplot exists."""
    output_dir.mkdir(parents=True, exist_ok=True)
    data_file = output_dir / "pacman-stats.csv"
    gpi_file = output_dir / "pacman-stats.gpi"
    svg_file = output_dir / "pacman-stats.svg"

    with data_file.open("w") as f:
        f.write(render_csv(per_year, totals(per_year), sep=","))

    colors = ["#0072bd", "#d95319", "#edb120", "#77ac30", "#4dbeee"]
    plots = ", \\\n".join(
        f"     '{data_file.name}' using 1:{i + 2} with linespoints "
        f"lc rgb '{colors[i]}' pt {i + 1} lw 2 title '{m.capitalize()}'"
        for i, m in enumerate(METRICS)
    )
    gpi = f"""set terminal svg enhanced size 800,600 font "Sans,10"
set output "{svg_file.name}"
set title "Pacman package activity"
set grid
set xlabel "Year"
set ylabel "Count"
set xtics rotate by -45
set key outside bottom horizontal
set style data linespoints
plot {plots}
"""
    gpi_file.write_text(gpi)

    gnuplot = shutil.which("gnuplot")
    if not gnuplot:
        print(
            f"Wrote {gpi_file} (install gnuplot or run it manually to render {svg_file.name})",
            file=sys.stderr,
        )
        return
    subprocess.run([gnuplot, gpi_file.name], cwd=output_dir, check=True)
    print(f"Wrote {svg_file}", file=sys.stderr)


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Analyze your Arch Linux package history from /var/log/pacman.log"
    )
    parser.add_argument(
        "logfile",
        nargs="?",
        default=DEFAULT_LOG,
        help=f"path to pacman.log (default: {DEFAULT_LOG})",
    )
    parser.add_argument(
        "-f",
        "--format",
        choices=["csv", "tsv", "markdown", "json", "html"],
        default="csv",
        help="output format (default: csv)",
    )
    parser.add_argument(
        "-o", "--output", type=Path, help="write output to file instead of stdout"
    )
    parser.add_argument(
        "--skip-failed-transactions",
        action="store_true",
        help="don't count packages that were part of a failed/interrupted transaction",
    )
    parser.add_argument(
        "--no-summary", action="store_true", help="don't print the summary to stderr"
    )
    parser.add_argument(
        "--plot",
        type=Path,
        metavar="DIR",
        help="write stats.csv + .gpi (and .svg if gnuplot is installed) into DIR",
    )
    args = parser.parse_args(argv)

    log_path = Path(args.logfile)
    if not log_path.is_file():
        parser.error(f"log file not found: {log_path}")

    per_year, summary = parse_log(
        log_path.read_text(errors="replace").splitlines(),
        skip_failed_transactions=args.skip_failed_transactions,
    )
    if not per_year:
        parser.error(f"no timestamped pacman entries found in {log_path}")

    totals_ = totals(per_year)
    installed_now = currently_installed_packages()

    if args.format == "json":
        output = render_json(per_year, totals_, summary, installed_now)
    elif args.format == "markdown":
        output = render_markdown(per_year, totals_)
    elif args.format == "html":
        output = render_html(per_year, totals_, summary, installed_now, installed_now)
    else:
        output = render_csv(per_year, totals_, sep="," if args.format == "csv" else "\t")

    if args.output:
        args.output.write_text(output)
        print(f"Wrote {args.output}", file=sys.stderr)
    else:
        sys.stdout.write(output)

    if args.plot:
        write_plot(args.plot, per_year)

    if not args.no_summary and args.format != "json":
        print(
            f"Arch install date : {summary['install_date']}",
            file=sys.stderr,
        )
        print(f"Last activity     : {summary['last_activity']}", file=sys.stderr)
        if installed_now is not None:
            print(
                f"Currently installed: {installed_now} packages",
                file=sys.stderr,
            )
        print(
            f"Pacman commands   : {summary['pacman_commands']} "
            f"({summary['database_syncs']} database syncs, "
            f"{summary['failed_transactions']} failed transactions)",
            file=sys.stderr,
        )
        print(
            f"Hook/scriptlet    : {summary['hook_runs']} hook runs + "
            f"{summary['scriptlet_output']} scriptlet output lines "
            f"({summary['unparsed_lines']} unparsed)",
            file=sys.stderr,
        )

    return 0


if __name__ == "__main__":
    sys.exit(main())
