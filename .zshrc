# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Created by `pipx` on 2025-02-10 20:34:32
export PATH="$PATH:/home/daxis/.local/bin"

# Ruby path
export PATH="$PATH:/home/daxis/.local/share/gem/ruby/3.3.0/bin"

# OMZ path
export ZSH="$HOME/.oh-my-zsh"

# Set prompt
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set editor
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export VISUAL="${EDITOR}"

# Set bat as manpager
export BAT_THEME="ansi"
export BAT_STYLE="full"
#export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Set neovim as manpager
export MANPAGER="nvim +Man!"

# Set some cool ZSH options
setopt nocaseglob          # Case insensitive autocompletions
setopt nocasematch         # Case insensitive autocompletions
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED         # The completion menu takes less space
setopt AUTO_LIST           # Automatically list choices on ambiguous completion
setopt COMPLETE_IN_WORD    # Complete from both ends of a word
setopt correct             # Auto-corrections
setopt AUTOCD              # Change directory just by typing its name
setopt PROMPT_SUBST        # Enable command substitution in prompt

# Load engine (completions)
autoload -Uz compinit

for dump in ~/.config/zsh/zcompdump(N.mh+24); do
  compinit -d ~/.config/zsh/zcompdump
done

compinit -C -d ~/.config/zsh/zcompdump

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
precmd () { vcs_info }
_comp_options+=(globdots)

zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'
zstyle ':completion:*' matcher-list \
		'm:{a-zA-Z}={A-Za-z}' \
		'+r:|[._-]=* r:|=*' \
		'+l:|=*'
zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

# Set waiting dots
expand-or-complete-with-dots() {
  echo -n "\e[31m…\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# Set command not found handler (fetch pacman files database first with pacman -Fy)
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: Command not found!: %s\n' "$1"
    local entries=(
        ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
    )
    if (( ${#entries[@]} ))
    then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"
        do
            # (repo package version file)
            local fields=(
                ${(0)entry}
            )
            if [[ "$pkg" != "${fields[2]}" ]]
            then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Archive extraction (usage: ex <file>)
ex() {
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1    ;;
      *.tar.gz)    tar xzf $1    ;;
      *.bz2)       bunzip2 $1    ;;
      *.rar)       unrar x $1    ;;
      *.gz)        gunzip $1     ;;
      *.tar)       tar xf $1     ;;
      *.tbz2)      tar xjf $1    ;;
      *.tgz)       tar xzf $1    ;;
      *.zip)       unzip $1      ;;
      *.Z)         uncompress $1 ;;
      *.7z)        7z x $1       ;;
      *.deb)       ar x $1       ;;
      *.tar.xz)    tar xf $1     ;;
      *.tar.zst)   unzstd xf $1  ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Check archlinux plugin commands here
#https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

plugins=(
    archlinux
    auto-notify
    colored-man-pages
    colorize
    fancy-ctrl-z
    git
    sudo
    web-search
    you-should-use
    zsh-autopair
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode
)

# Bind ESC to jk in zsh-vi-mode
function zvm_config() {
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
}

# Replace zsh's default readkey engine (ZLE to NEX)
ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX

source $ZSH/oh-my-zsh.sh

# Some useful aliases
alias ls='eza -a --icons'
alias lal='eza -al --icons'
alias la='eza -a --tree --level=1 --icons'
alias l.='eza -a | egrep "^\."'  # Show only hidden files
alias q='exit'
alias z='cd'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias cp='cp -i' # Confirm before overwriting something
alias mv='mv -i' # Confirm before overwriting something
alias rm='rm -i' # Confirm before removing something
alias mkdir='mkdir -p' # Create parent directories on the fly
alias ping='ping -c 5'
alias df='df -h'
alias du='du -h'
alias ysua='yay -Sua' # Update only AUR packages
alias yd='yay --devel'
alias yrsn='yay -Rsn'
alias yrsu='yay -Rsu'
alias yrsnu='yay -Rsnu'
alias ys='yay -S'
alias yss='yay -Ss'
alias yqdtq='yay -Qdtq'
alias yqet='yay -Qet'
alias yqi='yay -Qi'
alias ysi='yay -Si'
alias ysii='yay -Sii' # List reverse dependencies
alias yrq='yay -Rsn $(yay -Qdtq)' # List & remove all unneeded dependencies
alias yi="yay -Slq|fzf -m --style full --preview 'cat <(yay -Qi {1}|grep -e \"Install Reason\";echo '') <(yay`` -Si {1}) <(yay -Fl {1}|awk \"{print \$2}\")' | xargs -ro yay -S"
alias yu="yay -Qq|fzf -m --style full --preview \"yay -Qil {}\" | xargs -ro yay -Rsn"
alias psyu='sudo pacman -Syu'
alias psyyu='sudo pacman -Syyu' # Update only standard packages
alias prsn='sudo pacman -Rsn'
alias prsu='sudo pacman -Rsu'
alias prsnu='sudo pacman -Rsnu'
alias ps='sudo pacman -S'
alias pss='pacman -Ss'
alias pqdtq='pacman -Qdtq'
alias pqet='pacman -Qet'
alias pqi='pacman -Qi'
alias psi='pacman -Si'
alias psii='pacman -Sii' # List reverse dependencies
alias prq='sudo pacman -Rsn $(pacman -Qtdq)' # List & remove all unneeded dependencies
alias unlock='sudo rm -f /var/lib/pacman/db.lck' # Unlock pacman
alias ftldr='compgen -c | fzf --style full | xargs tldr' # Search for man pages with tldr + fzf
alias fman='compgen -c | fzf --style full | xargs man' # Search for man pages with man + fzf
alias src='source ~/.zshrc'
alias ttc='tty-clock -C6 -c'
alias expacs="expac -S '%r/%n: %D'" # List dependencies w/o additional info
alias n='nvim'
alias dv='dirs -v'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias psmem='ps auxf | sort -nr -k 4 | head -10' # Show top 10 memory-consuming processes
alias pscpu='ps auxf | sort -nr -k 3 | head -10' # Show top 10 CPU-consuming processes
alias ssn='sudo shutdown now'
alias sr='sudo reboot'
alias jctl='journalctl -p 3-xb' # Show logs with priority 3 and above (errors)
alias fz="fzf --style full --preview 'bat --color=always -n {}'"

# FZF integration + key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# FZF previews
export FZF_CTRL_T_OPTS="--style full --preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--style full --preview 'eza --tree --color=always {} | head -200'"

# Zoxide integration
eval "$(zoxide init zsh)"

# Zellij integration
eval "$(zellij setup --generate-auto-start zsh)"

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r

# Display colorscripts
#colorscript -r

# Auto-start "zombie-zfetch"
source $HOME/.config/zfetch/zfetchrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Atuin integration (pretty history)
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# Wikiman integration
source /usr/share/wikiman/widgets/widget.zsh

# Pay-respects (better command-not-found) integration
eval "$(pay-respects zsh --alias)"

# Yazi integration
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Carapace integration (argument completion)
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# broot integration
source /home/daxis/.config/broot/launcher/bash/br
