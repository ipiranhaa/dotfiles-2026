# macOS Dotfiles

A modular and clean setup to manage your macOS system settings, shell configurations, and software dependencies.

## Structure

```text
├── bootstrap.sh            # Main installation & symlinking script
├── Brewfile                # Homebrew packages, casks, and Mac App Store apps
├── macos.sh                # Script to configure macOS defaults
├── README.md               # Documentation
├── ghostty/
│   └── config              # Ghostty terminal emulator configuration
├── git/
│   ├── .gitconfig          # Git configuration
│   └── .gitignore_global   # Global Git ignore rules
├── starship/
│   └── starship.toml       # Starship shell prompt configuration
└── zsh/
    └── .zshrc              # Shell configurations (Oh My Zsh, Starship & plugins)
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
1. **Creates Symlinks**: Backs up any existing configurations (e.g. `.zshrc`, `.gitconfig`, `.gitignore_global`, `starship.toml`, and ghostty `config`) by renaming them to `*.bak` and creates symlinks pointing to this folder.
2. **Installs Homebrew**: Installs Homebrew if it is missing.
3. **Installs Packages**: Runs `brew bundle` to install CLI tools (like Starship) and applications (like Ghostty & FiraCode Nerd Font) listed in the `Brewfile`.
4. **Installs Oh My Zsh & Plugins**: Installs Oh My Zsh (if missing) and clones custom plugins (`zsh-autosuggestions` and `zsh-syntax-highlighting`).
5. **Applies macOS Preferences**: Prompts you to run `macos.sh` which applies typical power-user macOS system settings (Dock preferences, fast key repeat, Finder tweaks, etc.).

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
