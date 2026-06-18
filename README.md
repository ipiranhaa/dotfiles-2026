# macOS Dotfiles

A modular and clean setup to manage your macOS system settings, shell configurations, and software dependencies.

## Structure

```text
├── bootstrap.sh            # Main installation & symlinking script
├── Brewfile                # Homebrew packages, casks, and Mac App Store apps
├── macos.sh                # Script to configure macOS defaults
├── README.md               # Documentation
├── git/
│   ├── .gitconfig          # Git configuration
│   └── .gitignore_global   # Global Git ignore rules
└── zsh/
    └── .zshrc              # Shell configurations
```

## Setup / Installation

1. **Clone the repository** (if not already done):
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/Documents/dotfiles
   cd ~/Documents/dotfiles
   ```

2. **Make the script executable**:
   ```bash
   chmod +x bootstrap.sh
   ```

3. **Run the bootstrap script**:
   ```bash
   ./bootstrap.sh
   ```

### What `bootstrap.sh` does:
1. **Creates Symlinks**: Backs up any existing `.zshrc`, `.gitconfig`, or `.gitignore_global` files (renaming them to `*.bak`) and creates symlinks pointing to this folder.
2. **Installs Homebrew**: Installs Homebrew if it is missing.
3. **Installs Packages**: Runs `brew bundle` to install CLI tools and apps listed in `Brewfile`.
4. **Applies macOS Preferences**: Prompts you to run `macos.sh` which applies typical power-user macOS system settings (Dock preferences, fast key repeat, Finder tweaks, etc.).

---

## Keeping Things Updated

### Updating your applications list (`Brewfile`)
When you install a new app via brew or cask (e.g., `brew install tree`), you can update the `Brewfile` to track it:
```bash
# Export all currently installed homebrew packages, casks, and taps
brew bundle dump --force
```

### Applying remote changes
If you update your dotfiles on another machine, pull the latest changes and run:
```bash
git pull origin main
./bootstrap.sh
```
The script is idempotent, so running it multiple times is perfectly safe.
