#!/usr/bin/env bash

# bootstrap.sh
# Idempotent setup script for setting up macOS dotfiles and dependencies.

# Exit immediately if a command exits with a non-zero status
set -e

# Get the absolute path of this script's directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting dotfiles setup..."

# Helper function to symlink files safely with a backup mechanism
link_file() {
    local source="$1"
    local target="$2"

    # Resolve target parent directory
    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ] || [ -L "$target" ]; then
        # Check if already linked correctly
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
            echo "✔ Already linked: $target"
            return
        fi
        
        local backup="${target}.bak"
        echo "⚠ File exists: $target. Backing up to $backup"
        mv "$target" "$backup"
    fi

    echo "🔗 Linking $source -> $target"
    ln -s "$source" "$target"
}

# --- 1. Symlink Configuration Files ---
echo "Creating symlinks..."
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

# --- 2. Install Homebrew ---
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    # Note: On non-interactive runs, you can prepend CI=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configure Homebrew paths for the current shell session
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✔ Homebrew is already installed."
fi

# --- 3. Install Brew Dependencies ---
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo "Installing Brew dependencies from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
else
    echo "⚠ No Brewfile found at $DOTFILES_DIR/Brewfile"
fi

# --- 4. Install Oh My Zsh and Plugins ---
ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✔ Oh My Zsh is already installed."
fi

echo "Installing Oh My Zsh plugins..."
# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
    echo "Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
else
    echo "✔ zsh-autosuggestions is already installed."
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
    echo "Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
else
    echo "✔ zsh-syntax-highlighting is already installed."
fi

# --- 4. macOS Defaults (Optional) ---
echo ""
read -p "Do you want to configure macOS system defaults? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$DOTFILES_DIR/macos.sh" ]; then
        echo "Running macos.sh..."
        chmod +x "$DOTFILES_DIR/macos.sh"
        bash "$DOTFILES_DIR/macos.sh"
    else
        echo "⚠ macos.sh not found!"
    fi
else
    echo "Skipping macOS system configuration."
fi

echo "🎉 Dotfiles setup complete!"
