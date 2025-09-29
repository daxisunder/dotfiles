#!/usr/bin/env bash

# Colors
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
CYAN="\033[36m"
DARKGRAY="\033[90m"
DARKYELLOW="\033[33;2m"
DARKCYAN="\033[36;2m"
DARKMAGENTA="\033[35;2m"
RESET="\033[0m"

function show_git_status() {
    if ! command -v git >/dev/null 2>&1; then
        echo -e "${RED} Git is not installed or not in PATH.${RESET}"
        return
    fi

    status=$(git status --porcelain=v2 --branch)
    if [[ -z "$status" ]]; then
        echo -e "${GREEN} Clean working tree!${RESET}"
        return
    fi

    # --- Branch Info ---
    branch=$(echo "$status" | grep "^# branch.head" | sed 's/# branch.head //')
    upstream=$(echo "$status" | grep "^# branch.upstream" | sed 's/# branch.upstream //')
    ahead=$(echo "$status" | grep "^# branch.ab" | sed 's/# branch.ab //')

    aheadCount=0
    behindCount=0
    if [[ -n "$ahead" ]]; then
        aheadCount=$(echo "$ahead" | awk '{print $1}' | tr -d '+')
        behindCount=$(echo "$ahead" | awk '{print $2}' | tr -d '-')
    fi

    # --- Tag Info ---
    tagAtHead=$(git describe --tags --exact-match 2>/dev/null)
    nearestTag=$(git describe --tags 2>/dev/null)
    remoteTags=$(git ls-remote --tags "$upstream" 2>/dev/null | sed 's/.*refs\/tags\///')
    localTags=$(git tag --points-at HEAD)
    unpushedTags=$(comm -23 <(echo "$localTags" | sort) <(echo "$remoteTags" | sort))

    echo ""
    if [[ -n "$tagAtHead" ]]; then
        echo -e "  ${DARKYELLOW}On tag:${RESET} ${CYAN}$tagAtHead${RESET}"
    elif [[ -n "$nearestTag" ]]; then
        echo -e "  ${DARKYELLOW}Nearest tag:${RESET} ${DARKCYAN}$nearestTag${RESET}"
    fi
    if [[ -n "$unpushedTags" ]]; then
        while read -r t; do
            [[ -z "$t" ]] && continue
            echo -e "  ${DARKYELLOW}Unpushed tag:${RESET} ${MAGENTA}$t${RESET}"
        done <<< "$unpushedTags"
    fi

    # --- Remote commits not pulled ---
    if [[ $behindCount -gt 0 && -n "$upstream" ]]; then
        echo ""
        echo -e "  ${MAGENTA}Remote:${RESET} [ ${DARKMAGENTA}$behindCount${RESET}] | ${GREEN}$upstream${RESET} | ${DARKGRAY}(git pull)${RESET}"
        echo -e " ${DARKGRAY}───────────────────────────────${RESET}"
        git log "HEAD..$upstream" --pretty=format:"%h %s" -n "$behindCount" | while read -r c; do
            echo -e "   󰇚 ${RED}$c${RESET}"
        done
        echo ""
    else
        echo ""
        echo -e "  ${MAGENTA}Remote:${RESET} [ ${DARKGRAY}$behindCount${RESET}] | ${GREEN}$upstream${RESET}"
    fi

    # --- Local commits not pushed ---
    if [[ $aheadCount -gt 0 ]]; then
        echo -e "  ${MAGENTA}HEAD:${RESET} [ ${DARKCYAN}$aheadCount${RESET}] | ${YELLOW}$branch${RESET} | ${DARKGRAY}(git push)${RESET}"
        echo -e " ${DARKGRAY}───────────────────────────────${RESET}"

        if [[ -z "$upstream" ]]; then
            upstream="origin/HEAD"
        fi

        log=$(git log --oneline --decorate --graph -n 7)
        unpushed=$(git log "$upstream..HEAD" --pretty=format:"%h")

        while IFS= read -r line; do
            if [[ "$line" =~ ([0-9a-f]{7,}) ]]; then
                sha="${BASH_REMATCH[1]}"
                if grep -q "$sha" <<< "$unpushed"; then
                    echo -e "   ${GREEN}$line${RESET}"
                else
                    echo -e "   ${DARKGRAY}$line${RESET}"
                fi
            else
                echo -e "   ${DARKGRAY}$line${RESET}"
            fi
        done <<< "$log"
    else
        echo -e "  ${MAGENTA}HEAD:${RESET} [ ${DARKGRAY}$aheadCount${RESET}] | ${YELLOW}$branch${RESET}"
    fi

    echo ""
    echo -e " ───────────────────────────────"
    echo ""

    # --- File Buckets ---
    staged=()
    unstaged=()
    untracked=()

    while IFS= read -r line; do
        if [[ "$line" =~ ^\?\ (.+)$ ]]; then
            untracked+=("${BASH_REMATCH[1]}")
        elif [[ "$line" =~ ^[12]\ ([A-Z\.])([A-Z\.])\ .*[\ ](.+)$ ]]; then
            X="${BASH_REMATCH[1]}"
            Y="${BASH_REMATCH[2]}"
            file="${BASH_REMATCH[3]}"
            [[ "$X" != "." ]] && staged+=("$X $file")
            [[ "$Y" != "." ]] && unstaged+=("$Y $file")
        fi
    done <<< "$status"

    if [[ ${#staged[@]} -eq 0 && ${#unstaged[@]} -eq 0 && ${#untracked[@]} -eq 0 && $aheadCount -eq 0 ]]; then
        git log --oneline --decorate --graph -n 7
    fi

    if [[ ${#staged[@]} -gt 0 ]]; then
        echo -e "  ${GREEN}Staged changes (${#staged[@]})${RESET} | ${DARKGRAY}(gcc | git restore --staged)${RESET}"
        for entry in "${staged[@]}"; do
            code="${entry%% *}"
            file="${entry#* }"
            case "$code" in
                M) echo -e "      ${GREEN}$file${RESET}" ;;
                A) echo -e "      ${GREEN}$file${RESET}" ;;
                D) echo -e "      ${GREEN}$file${RESET}" ;;
                R) echo -e "      ${GREEN}$file${RESET}" ;;
            esac
        done
        echo ""
    fi

    if [[ ${#unstaged[@]} -gt 0 ]]; then
        echo -e "  ${YELLOW}Unstaged changes (${#unstaged[@]})${RESET} | ${DARKGRAY}(ga | git restore)${RESET}"
        for entry in "${unstaged[@]}"; do
            code="${entry%% *}"
            file="${entry#* }"
            case "$code" in
                M) echo -e "      ${YELLOW}$file${RESET}" ;;
                D) echo -e "      ${YELLOW}$file${RESET}" ;;
            esac
        done
        echo ""
    fi

    if [[ ${#untracked[@]} -gt 0 ]]; then
        echo -e "  ${MAGENTA}Untracked (${#untracked[@]})${RESET} | ${DARKGRAY}(ga)${RESET}"
        for file in "${untracked[@]}"; do
            echo -e "      ${DARKMAGENTA}$file${RESET}"
        done
        echo ""
    fi
}

# Run if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    show_git_status
fi

