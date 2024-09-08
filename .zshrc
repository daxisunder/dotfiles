# If you come from bash you might have to change your $PATH.
#export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# Set prompt
ZSH_THEME="jonathan"

# Set editor
export VISUAL="${EDITOR}"
export EDITOR="nvim"

# Set some cool ZSH options
setopt nocaseglob          # Case insensitive autocompletions
setopt nocasematch         # Case insensitive autocompletions
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED		   # The completion menu takes less space
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

# command not found
command_not_found_handler() {
	printf "%s%s? I don't know what that is!\n" "$acc" "$0" >&2
    return 127
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
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Set-up icons for files/folders in terminal (eza)
alias ls='eza -a --icons'
alias lal='eza -al --icons'
alias la='eza -a --tree --level=1 --icons'

# Some useful aliases
alias x='exit'
alias yayd='yay --devel'
alias yayrn='yay -Rsn'
alias yayru='yay -Rsu'
alias yayrnu='yay -Rsnu'
alias yays='yay -S'
alias yayss='yay -Ss'
alias yayqd='yay -Qdt'
alias yayqe='yay -Qet'
alias yayqi='yay -Qi'
alias fman='compgen -c | fzf | xargs man' # Search for man pages

# FZF integration + key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# Zoxide integration
eval "$(zoxide init zsh)"

# Zellij integration
eval "$(zellij setup --generate-auto-start zsh)"

# Display Pokemon-colorscripts
#Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r

# Auto-start "zombie-zfetch"
source $HOME/.config/zfetch/zfetchrc
