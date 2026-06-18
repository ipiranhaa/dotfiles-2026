# Zsh Configuration
# This file will be symlinked to ~/.zshrc

# PATH configurations
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# If Homebrew is installed, load its environment (Apple Silicon or Intel)
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Zsh History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

# Basic Aliases
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"
alias reload="source ~/.zshrc"
alias dotfiles="cd ~/Documents/dotfiles"

# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Oh My Zsh Theme (set to empty to allow Starship to control the prompt)
ZSH_THEME=""

# Oh My Zsh Plugins
plugins=(git sudo zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
if [ -d "$ZSH" ]; then
    source "$ZSH/oh-my-zsh.sh"
else
    # Fallback completion if Oh My Zsh is not yet installed
    autoload -Uz compinit
    compinit
fi

# Load Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

