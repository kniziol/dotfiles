#!/bin/sh

source config/path.sh
source utility/print.sh

BACKUP_SUFFIX="_-_before_dotfiles"

print_header "Starting..."

#
# Install Oh My Zsh, if not installed
# https://ohmyz.sh
#
if test ! -d "$ZSH"; then
#if test ! $(which omz); then
  print_negative "Oh My Zsh was not found. Installing..."
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

#
# Install Homebrew, if not installed
# https://brew.sh
#
if test ! $(which brew); then
  print_negative "Homebrew was not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(brew shellenv)"' >> $HOME/.zprofile
  eval "$(brew shellenv)"
fi

#
# Install Powerlevel10k Zsh theme, if not installed
# https://github.com/romkatv/powerlevel10k
#
if ! brew ls --versions powerlevel10k > /dev/null; then
  print_negative "The Powerlevel10k Zsh theme was not found. Installing..."
  brew install powerlevel10k
fi

#
# Make a backup of configuration files from the $HOME directory
# Files only, do not make a backup of symlinks
#
[ ! -L "$HOME/.zshrc" ] && [ -f "$HOME/.zshrc" ] && mv $HOME/.zshrc $HOME/.zshrc$BACKUP_SUFFIX
[ ! -L "$HOME/.p10k.zsh" ] && [ -f "$HOME/.p10k.zsh" ] && mv $HOME/.p10k.zsh $HOME/.p10k.zsh$BACKUP_SUFFIX
[ ! -L "$HOME/.gitconfig" ] && [ -f "$HOME/.gitconfig" ] && mv $HOME/.gitconfig $HOME/.gitconfig$BACKUP_SUFFIX
[ ! -L "$HOME/.gitconfig-github" ] && [ -f "$HOME/.gitconfig-github" ] && mv $HOME/.gitconfig-github $HOME/.gitconfig-github$BACKUP_SUFFIX
[ ! -L "$HOME/.gitconfig-meritoo" ] && [ -f "$HOME/.gitconfig-meritoo" ] && mv $HOME/.gitconfig-meritoo $HOME/.gitconfig-meritoo$BACKUP_SUFFIX
[ ! -L "$HOME/.gitconfig-polcode" ] && [ -f "$HOME/.gitconfig-polcode" ] && mv $HOME/.gitconfig-polcode $HOME/.gitconfig-polcode$BACKUP_SUFFIX
[ ! -L "$HOME/.gitignore_global" ] && [ -f "$HOME/.gitignore_global" ] && mv $HOME/.gitignore_global $HOME/.gitignore_global$BACKUP_SUFFIX
print_positive "Created backup of configuration files from the ~/ directory"

#
# Symlink files from the ~/.dotfiles into the $HOME directory
#
ln -sf $DOTFILES/.zshrc $HOME
ln -sf $DOTFILES/.p10k.zsh $HOME
ln -sf $DOTFILES/.gitconfig $HOME
ln -sf $DOTFILES/.gitconfig-github $HOME
ln -sf $DOTFILES/.gitconfig-meritoo $HOME
ln -sf $DOTFILES/.gitconfig-polcode $HOME
ln -sf $DOTFILES/.gitignore_global $HOME
print_positive "Symlinked files from the ~/.dotfiles directory to the ~/ directory"

#
# Make sure we’re using the latest Homebrew
# Upgrade any already-installed formulae
#
brew update
brew upgrade
print_positive "Homebrew and all formulae updated"

#
# Install all dependencies and applications with Homebrew Bundle (see the brewfile)
# https://github.com/Homebrew/homebrew-bundle
#
rm -f brewfile.lock.json
brew tap homebrew/bundle
brew bundle --file Brewfile
print_positive "Installed all dependencies and applications using the Homebrew Bundle"

#
# Remove stale lock files and outdated downloads
#
brew cleanup
print_positive "Homebrew cleaned"

#
# Install Node.js and npm
#
sudo n latest
sudo n prune
print_positive "Installed the latest versions of Node.js and npm"

#
# Set macOS preferences - we will run this last because this will reload the shell
#
source .macos
print_positive "macOS preferences updated"

print_footer "Done"
