#!/usr/bin/env python3

import subprocess
import re
from rich import print
from rich.console import Console
from rich.table import Table
from rich.panel import Panel

console = Console()


def run_git(cmd):
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout.strip().splitlines()
    except Exception as e:
        print(f"[red]Error running {' '.join(cmd)}:[/red] {e}")
        return []


def get_branch_info(status_lines):
    branch = upstream = ahead = ""
    for line in status_lines:
        if line.startswith("# branch.head"):
            branch = line.replace("# branch.head ", "")
        elif line.startswith("# branch.upstream"):
            upstream = line.replace("# branch.upstream ", "")
        elif line.startswith("# branch.ab"):
            ahead = line.replace("# branch.ab ", "")
    ahead_count, behind_count = 0, 0
    if ahead:
        match = re.match(r"\+(\d+) -(\d+)", ahead)
        if match:
            ahead_count = int(match.group(1))
            behind_count = int(match.group(2))
    return branch, upstream, ahead_count, behind_count


def get_tags(upstream):
    tag_at_head = subprocess.run(
        ["git", "describe", "--tags", "--exact-match"], capture_output=True, text=True
    ).stdout.strip()
    nearest_tag = subprocess.run(
        ["git", "describe", "--tags"], capture_output=True, text=True
    ).stdout.strip()
    remote_tags = subprocess.run(
        ["git", "ls-remote", "--tags", upstream], capture_output=True, text=True
    ).stdout
    remote_tags = [
        re.sub(r".*refs/tags/", "", line) for line in remote_tags.splitlines()
    ]
    local_tags = (
        subprocess.run(
            ["git", "tag", "--points-at", "HEAD"], capture_output=True, text=True
        )
        .stdout.strip()
        .splitlines()
    )
    unpushed_tags = [tag for tag in local_tags if tag and tag not in remote_tags]
    return tag_at_head, nearest_tag, unpushed_tags


def show_commits_diff(upstream, behind_count):
    if behind_count > 0:
        commits = run_git(
            [
                "git",
                "log",
                f"HEAD..{upstream}",
                "--pretty=format:%h %s",
                "-n",
                str(behind_count),
            ]
        )
        print(
            f"\n[magenta] Remote:[/magenta] [dark_magenta] {behind_count}[/dark_magenta] | [green]{upstream}[/green] | [dim](git pull)[/dim]"
        )
        print("[dim] ───────────────────────────────[/dim]")
        for c in commits:
            print(f"[dark_red]   󰇚 {c}[/dark_red]")
    else:
        print(
            f"\n[magenta] Remote:[/magenta] [dim] 0[/dim] | [green]{upstream}[/green]"
        )


def show_local_commits(branch, upstream, ahead_count):
    print(
        f"[magenta] HEAD:[/magenta] [dark_cyan] {ahead_count}[/dark_cyan] | [yellow]{branch}[/yellow] | [dim](git push)[/dim]"
    )
    print("[dim] ───────────────────────────────[/dim]")
    log = run_git(["git", "log", "--oneline", "--decorate", "--graph", "-n", "7"])
    unpushed = run_git(["git", "log", f"{upstream}..HEAD", "--pretty=format:%h"])
    for line in log:
        match = re.search(r"([0-9a-f]{7,})", line)
        if match and match.group(1) in unpushed:
            print(f"[green]   {line}[/green]")
        else:
            print(f"[dim]   {line}[/dim]")


def parse_file_buckets(status_lines):
    staged, unstaged, untracked = [], [], []
    for line in status_lines:
        if line.startswith("? "):
            untracked.append(line[2:])
        elif re.match(r"^[12] (\S)(\S) .* (.+)$", line):
            match = re.match(r"^[12] (\S)(\S) .* (.+)$", line)
            x, y, file = match.groups()
            if x != ".":
                staged.append((x, file))
            if y != ".":
                unstaged.append((y, file))
    return staged, unstaged, untracked


def show_file_bucket(title, entries, color, help_text, icon_map):
    if not entries:
        return
    print(f"[{color}]{title} ({len(entries)})[/] [dim]| {help_text}[/dim]")
    for code, file in entries:
        icon = icon_map.get(code, "")
        print(f"[{color}]   {icon}  {file}[/]")


def show_git_status():
    if not shutil.which("git"):
        print("[red] Git is not installed or not in PATH.[/red]")
        return

    status_lines = run_git(["git", "status", "--porcelain=v2", "--branch"])
    if not status_lines:
        print("[green] Clean working tree![/green]")
        return

    branch, upstream, ahead_count, behind_count = get_branch_info(status_lines)
    tag_at_head, nearest_tag, unpushed_tags = get_tags(upstream)

    print()
    if tag_at_head:
        print(f"[dark_yellow]  On tag:[/] [cyan]{tag_at_head}[/cyan]")
    elif nearest_tag:
        print(f"[dark_yellow]  Nearest tag:[/] [dark_cyan]{nearest_tag}[/dark_cyan]")
    for tag in unpushed_tags:
        print(f"[dark_yellow]  Unpushed tag:[/] [magenta]{tag}[/magenta]")

    show_commits_diff(upstream, behind_count)
    if ahead_count > 0:
        show_local_commits(branch, upstream or "origin/HEAD", ahead_count)
    else:
        print(f"[magenta] HEAD:[/magenta] [dim] 0[/dim] | [yellow]{branch}[/yellow]")

    print("\n[dim] ───────────────────────────────[/dim]\n")

    staged, unstaged, untracked = parse_file_buckets(status_lines)

    if not staged and not unstaged and not untracked and ahead_count == 0:
        log = run_git(["git", "log", "--oneline", "--decorate", "--graph", "-n", "7"])
        for line in log:
            print(line)

    show_file_bucket(
        " Staged changes",
        staged,
        "green",
        "gcc | git restore --staged",
        {"M": "", "A": "", "D": "", "R": ""},
    )
    show_file_bucket(
        " Unstaged changes",
        unstaged,
        "yellow",
        "ga | git restore",
        {"M": "", "D": ""},
    )
    if untracked:
        print(f"[magenta]  Untracked ({len(untracked)})[/magenta] [dim]| (ga)[/dim]")
        for file in untracked:
            print(f"[dark_magenta]    {file}[/dark_magenta]")


if __name__ == "__main__":
    import shutil

    show_git_status()
