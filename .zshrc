# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/bin:$PATH"

# Cargo path
export PATH="$PATH:$HOME/.cargo/bin"

# Created by `pipx` on 2025-02-10 20:34:32
export PATH="$PATH:~/.local/bin"

# Ruby path
export PATH="$PATH:~/.local/share/gem/ruby/3.3.0/bin"

# Node path
export PATH="$PATH:/usr/bin/node"
export PATH="$PATH:~/node_modules/.bin"
export NODE_EXTRA_CA_CERTS="/etc/ssl/certs/ACCVRAIZ1.pem"

# Emacs path
export PATH="$HOME/.config/emacs/bin:$PATH"

# OMZ path
export ZSH="$HOME/.oh-my-zsh"

# Source api keys (has to be sourced before zsh-ai gemini provider)
source $HOME/projects/dotfiles/api.env

# ZSH AI integration with local AI models
export ZSH_AI_PROVIDER="ollama" # (anthropic (default), ollama (local), gemini, opennai)
export ZSH_AI_OLLAMA_MODEL="llama3.2"
export ZSH_AI_GEMINI_MODEL="gemini-2.5-flash"
export ZSH_AI_PROMPT_EXTEND="Always prefer modern CLI tools like ripgrep, fd, and bat."

# Set pop to use gmail
# export POP_SMTP_HOST=smtp-mail.outlook.com
# export POP_SMTP_PORT=587
# export POP_SMTP_USERNAME=daxisunder@hotmail.com
# export POP_SMTP_PASSWORD=pjrhwoufwvczawgu
export POP_FROM=onboarding@resend.dev
export POP_SIGNATURE="Sent with [Pop](https://github.com/charmbracelet/pop)!"

# XDG runtime dir (onedrive)
export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# Set ydotool socket path
export YDOTOOL_SOCKET="$HOME/.ydotool_socket"

# Add scripts to PATH
export SCRIPTS_DIR="$HOME/projects/dotfiles/scripts"
export PATH="$PATH:$SCRIPTS_DIR"

# Make all scripts executable
if [ -d "$SCRIPTS_DIR" ]; then
  find "$SCRIPTS_DIR" -type f -exec chmod +x {} \;
fi

# Set prompt
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set editor
export EDITOR="nvim"
export SUDO_EDITOR="${EDITOR}"
export VISUAL="${EDITOR}"

# Set bat as manpager
export BAT_THEME="ansi"
export BAT_STYLE="full"
#export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Set neovim as manpager
export MANPAGER="nvim +Man!"

# Use QEMU/KVM without sudo permissions
export LIBVIRT_DEFAULT_URI="qemu:///system"

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Set some cool ZSH options ('set -o' to see all options)
setopt no_case_glob            # Case insensitive autocompletions
setopt no_case_match           # Case insensitive autocompletions
setopt globdots                # Include dotfiles in globbing
setopt auto_menu               # Automatically highlight first element of completion menu
setopt menu_complete           # Use menu completion
setopt list_packed             # The completion menu takes less space
setopt auto_list               # Automatically list choices on ambiguous completion
setopt complete_in_word        # Complete from both ends of a word
setopt correct                 # Auto-corrections
setopt autocd                  # Change directory just by typing its name
setopt prompt_subst            # Enable command substitution in prompt
setopt interactive_comments    # Allow comments in interactive shell

# Set comment color (zsh-syntax-highlighting)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]="fg=#565f89"

# Load completion engine
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
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=0\;33'
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

# Archive extraction (usage: extract <file>)
# Github: https://github.com/xvoland/Extract/blob/master/extract.sh
function extract {
    if [ $# -eq 0 ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso|.zst>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    fi
    for n in "$@"; do
        if [ ! -f "$n" ]; then
          echo "'$n' - file doesn't exist"
          return 1
        fi
        case "${n%,}" in
          *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
              tar --auto-compress -xvf "$n" ;;
          *.lzma)      unlzma "$n" ;;
          *.lz4)       lz4 -d "$n" ;;
          *.appimage)  ./"$n" --appimage-extract ;;
          *.tar.lz4)   tar --use-compress-program=lz4 -xvf "$n" ;;
          *.tar.br)    tar --use-compress-program=pbzip2 -xvf "$n" ;;
          *.bz2)       bunzip2 "$n" ;;
          *.cbr|*.rar) unrar x -ad "$n" ;;
          *.gz)        gunzip "$n" ;;
          *.cbz|*.epub|*.zip) unzip "$n" ;;
          *.z)         uncompress "$n" ;;
          *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar|*.vhd)
              7z x "$n" ;;
          *.xz)        unxz "$n" ;;
          *.exe)       cabextract "$n" ;;
          *.cpio)      cpio -id < "$n" ;;
          *.cba|*.ace) unace x "$n" ;;
          *.zpaq)      zpaq x "$n" ;;
          *.arc)       arc e "$n" ;;
          *.cso)       ciso 0 "$n" "$n.iso" && extract "$n.iso" && rm -f "$n" ;;
          *.zlib)      zlib-flate -uncompress < "$n" > "${n%.*zlib}" && rm -f "$n" ;;
          *.dmg)
              mnt_dir=$(mktemp -d)
              hdiutil mount "$n" -mountpoint "$mnt_dir"
              echo "Mounted at: $mnt_dir" ;;
          *.tar.zst)   tar -I zstd -xvf "$n" ;;
          *.zst)       zstd -d "$n" ;;
          *)
              echo "extract: '$n' - unknown archive method"
              return 1
              ;;
        esac
    done
}

# Check plugin commands here: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/<plugin-name>
plugins=(
    auto-notify
    colored-man-pages
    fancy-ctrl-z
    safe-paste
    sudo
    you-should-use
    zsh-ai
    zsh-autopair
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode
)

# Replace zsh's default readkey engine (ZLE to NEX)
ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX

# Source Oh My Zsh
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
alias cpv='cp -vi' # Confirm before overwriting something (verbose)
alias mvv='mv -vi' # Confirm before overwriting something (verbose)
alias rmv='rm -vi' # Confirm before removing something (verbose)
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
alias yi="yay -Slq|fzf -m --preview 'bat --color=always <(yay -Qi {1}|grep -e \"Install Reason\";echo '') <(yay`` -Si {1}) <(yay -Fl {1}|awk \"{print \$2}\")' | xargs -ro yay -S"
alias yu="yay -Qq|fzf -m --preview \"yay -Qil {}\" | xargs -ro yay -Rsn"
alias psyu='sudo pacman -Syu'
alias psyyu='sudo pacman -Syyu' # Update only standard packages
alias prsn='sudo pacman -Rsn'
alias prsu='sudo pacman -Rsu'
alias prsnu='sudo pacman -Rsnu'
alias pacs='sudo pacman -S'
alias pss='pacman -Ss'
alias pqdtq='pacman -Qdtq'
alias pqet='pacman -Qet'
alias pqi='pacman -Qi'
alias psi='pacman -Si'
alias psii='pacman -Sii' # List reverse dependencies
alias prq='sudo pacman -Rsn $(pacman -Qtdq)' # List & remove all unneeded dependencies
alias unlock='sudo rm -f /var/lib/pacman/db.lck' # Unlock pacman
alias ftldr='compgen -c | fzf | xargs tldr' # Search for man pages with tldr + fzf (print page to stdout)
alias fman='compgen -c | fzf | xargs man' # Search for man pages with man + fzf (view page with $MANPAGER)
alias src='source ~/.zshrc'
alias ttc='tty-clock -C6 -c'
alias expacs="expac -S '%r/%n: %D'" # List dependencies w/o additional info
alias n='nvim'
alias v='vim'
alias e='emacs -nw'
alias dv='dirs -v'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias psmem='ps auxf | sort -nr -k 4 | head -10' # Show top 10 memory-consuming processes
alias pscpu='ps auxf | sort -nr -k 3 | head -10' # Show top 10 CPU-consuming processes
alias ssn='sudo shutdown now'
alias sr='sudo reboot'
alias jctl='journalctl -p 3' # Show logs with priority 3 and above (errors)
alias fz="fzf --preview 'bat --color=always -n {}'"
alias wcp='wl-color-picker'
alias wcpc='wl-color-picker clipboard'
alias gstat='/home/daxis/projects/dotfiles/scripts/Show-GitStatusBash.sh'

# FZF integration + key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# FZF theme
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --style=full \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --color=bg+:#1a1b26 \
  --color=border:#1a1b26 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#1a1b26 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

# FZF previews
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'eza --tree --color=always {}'"
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Zoxide integration
eval "$(zoxide init zsh)"

# Zellij integration
eval "$(zellij setup --generate-auto-start zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Atuin integration (pretty history)
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# Wikiman integration
source /usr/share/wikiman/widgets/widget.zsh

# Batman integration
export BAT_THEME="Dracula"
eval "$(batman --export-env)"

# Pay-respects (better command-not-found) integration
eval "$(pay-respects zsh)"

# Yazi integration
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Carapace integration (argument completion)
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# Broot integration
source /home/daxis/.config/broot/launcher/bash/br

# NVM integration
source /usr/share/nvm/init-nvm.sh

# Copilot CLI aliases
eval "$(gh copilot alias -- zsh)"

# Cheatsheet integration
export CHEAT_USE_FZF=true

# televisiion integration
eval "$(tv init zsh)"

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r

# Display colorscripts
#colorscript -r

# Auto-start "zombie-zfetch"
source $HOME/.config/zfetch/zfetchrc
