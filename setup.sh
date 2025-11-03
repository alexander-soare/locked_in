#!/bin/bash

set -e

# Custom bash setup.
echo "⚙️ Installing custom bash setup"
cp files/bashrc_custom ~/.bashrc_custom
echo "source ~/.bashrc_custom" >> ~/.bashrc
echo "✅ Done."

# Check if git is installed, and if not, install it.
if ! command -v git &> /dev/null
then
    echo "git could not be found, installing git..."
    sudo apt update
    sudo apt install -y git
    echo "✅ Done."
fi

# VSCode settings
echo "⚙️ Installing VSCode setup"
mkdir -p ~/.config/Code/User
cp files/vscode/keybindings.json ~/.config/Code/User
cp files/vscode/settings.json ~/.config/Code/User
echo "✅ Done."

# Fuzzy finder. Only do this if ~/.fzf does not already exist.
if [ -d ~/.fzf ]; then
    echo "~/.fzf already exists, skipping fzf installation."
else
    echo "⚙️ Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    bash ~/.fzf/install --all
    echo "✅ Done."
fi
 
# XCompose
# TODO: There's another step to make this work properly
echo "⚙️ Installing XCompose setup"
cp files/XCompose ~/.XCompose
echo "✅ Done."

echo "All done. Now restart your shell our run \`source ~/.bashrc\`"
