# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# Set prompt
ZSH_THEME="jonathan"

# Set editor
export VISUAL="nvim"
export EDITOR="nvim"

# Set case insensitive autocompletions
setopt nocaseglob
setopt nocasematch

# Set autocorrect
setopt correct

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r

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

# Search for man pages
alias fman='compgen -c | fzf | xargs man'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Zoxide integration
eval "$(zoxide init zsh)"

# Zellij integration
eval "$(zellij setup --generate-auto-start zsh)"
