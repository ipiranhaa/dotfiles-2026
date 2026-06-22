#!/usr/bin/env bash

# macOS system preferences configuration
# Derived from mathiasbynens/dotfiles

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Configuring macOS preferences..."

###############################################################################
# Keyboard & Input                                                            #
###############################################################################

# Keyboard: Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder: Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Finder: Use list view in all Finder windows by default
# Four-letter codes for the other views: `icnv` (icon), `clmv` (column), `glyv` (gallery)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist


###############################################################################
# Dock & Dashboard                                                            #
###############################################################################

# Dock: Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Dock: Speed up Dock showing/hiding transitions
defaults write com.apple.dock autohide-time-modifier -float 0.2
defaults write com.apple.dock autohide-delay -float 0

# Dock: Show active app indicators (dots)
defaults write com.apple.dock show-process-indicators -bool true

###############################################################################
# Screen & Energy Saving                                                      #
###############################################################################

# Save screenshots to the Downloads folder
defaults write com.apple.screencapture location -string "${HOME}/Downloads"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Enable subpixel font rendering on non-Apple LCDs
# defaults write NSGlobalDomain AppleFontSmoothing -int 1

###############################################################################
# Menu Bar & Control Center                                                   #
###############################################################################

# Control Center: Show battery percentage in the menu bar
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

###############################################################################
# Clean up                                                                    #
###############################################################################

# Restart affected apps to apply changes
for app in "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" &> /dev/null
done

echo "macOS preferences updated. Some changes may require a logout/restart to take effect."
