#!/bin/bash

set -e

WORK=0
GUI=0
CLAUDE=0

while [[ $# -gt 0 ]]; do
    case $1 in
    --work)
        WORK=1
        shift 1
        ;;
    --gui)
        GUI=1
        shift 1
        ;;
    --claude)
        CLAUDE=1
        shift 1
        ;;
    *)
        shift
        ;;
    esac
done

# Custom bash setup.
echo "⚙️  Installing custom bash setup"
cp files/bashrc_custom ~/.bashrc_custom
echo -e "\nsource ~/.bashrc_custom" >> ~/.bashrc
echo "✅ Done."

sudo apt update

# Install terminator and update config
sudo apt install -y terminator
cp files/terminator_config ~/.config/terminator/config

# Check if git is installed, and if not, install it.
if ! command -v git &> /dev/null
then
    echo "⚙️  git could not be found, installing git..."
    sudo apt install -y git
    echo "✅ Done."
fi

if command -v git &> /dev/null
then
    echo "⚙️  git found. Configuring globals..."
    git config --global user.name "Alexander Soare"
    if [ $WORK -eq 0 ]; then
        git config --global user.email "alexander.soare159@gmail.com"
    else
        git config --global user.email "alexander@co.bot"
    fi
fi

# VSCode settings
echo "⚙️  Installing VSCode setup"
mkdir -p ~/.config/Code/User
cp files/vscode/keybindings.json ~/.config/Code/User
cp files/vscode/settings.json ~/.config/Code/User
echo "✅ Done."

# Fuzzy finder. Only do this if ~/.fzf does not already exist.
if [ -d ~/.fzf ]; then
    echo "~/.fzf already exists, skipping fzf installation."
else
    echo "⚙️  Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    bash ~/.fzf/install --all
    echo "✅ Done."
fi
 
# XCompose
# TODO: There's another step to make this work properly
echo "⚙️  Installing XCompose setup"
cp files/XCompose ~/.XCompose
echo "✅ Done."

# UV
if ! command -v uv &> /dev/null
then
    echo "⚙️  uv could not be found, installing uv..."
    wget -qO- https://astral.sh/uv/install.sh | sh
    echo "✅ Done."
fi

# Nvtop
if ! command -v nvidia-smi &> /dev/null
then
    if ! command -v nvtop &> /dev/null
    then
        echo "⚙️  nvtop could not be found, installing nvtop..."
        sudo add-apt-repository ppa:quentiumyt/nvtop -y
        sudo apt install nvtop -y
        echo "✅ Done."
    fi
else
    echo "⚠️ nvidia-smi command not available. Skipping nvtop installation"
fi

# Docker
if command -v docker &> /dev/null
then
    echo "⚙️  docker found. Adding user to docker group..."
    sudo usermod -aG docker $USER
    echo "✅ Done."
fi

# ncdu
if ! command -v ncdu &> /dev/null
then
    echo "⚙️  ncdu not found. Installing ncdu..."
    sudo apt install ncdu -y
    echo "✅ Done."
fi

# AWS
if [ $WORK -eq 1 ] && ( ! command -v aws >/dev/null 2>&1 || ! aws --version | grep -q 'aws-cli/2' ); then
    echo "⚙️  aws-cli v2 could not be found, installing aws-cli v2..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --update
    rm -rf awscliv2.zip aws
    echo "✅ Done."
fi

# xclip
if ! command -v xclip &> /dev/null
then
    echo "⚙️  xclip not found. Installing xclip..."
    sudo apt install xclip -y
    echo "✅ Done."
fi

if [ $GUI -eq 1 ] && (! command -v brave-browser &> /dev/null)
then
    echo "⚙️  Brave browser not found. Installing Brave..."
    curl -fsS https://dl.brave.com/install.sh | sh
    echo "✅ Done."
fi

if [ $GUI -eq 1 ]
then
    echo "⚙️  Installing GNOME extension 'Always Show Titles in Overview'..."
    # Install the installer if it's not available.
    if ! command -v gnome-shell-extension-installer &> /dev/null
    then
        sudo wget -O /usr/local/bin/gnome-shell-extension-installer \
            https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer
        sudo chmod +x /usr/local/bin/gnome-shell-extension-installer
    fi
    # Install the extension
    gnome-shell-extension-installer 1689
    # Enable the extension
    EXT_UUID=$(gnome-extensions list | grep -i 'Always-Show-Titles-In-Overview@gmail.com' | head -n1)
    if [ -n "$EXT_UUID" ]; then
        gnome-extensions enable "$EXT_UUID" || true
    fi
    # Make sure user extensions are not disabled globally.
    gsettings set org.gnome.shell disable-user-extensions false
    echo "✅ Done. You may need to log out and back in for the extension to load."
fi

if [ $CLAUDE -eq 1 ]
then
    if ! command -v claude &> /dev/null
    then
        echo "⚙️  claude not found. Installing claude..."
        curl -fsSL https://claude.ai/install.sh | bash
        echo "✅ Done."
    fi
    echo "⚙️  installing claude skills"
    mkdir -p ~/.claude/skills
    for skill in files/claude_skills/*/; do
        skill_name=$(basename "$skill")
        echo -e "  ⚙️  installing skill: \033[0;32m$skill_name\033[0m"
        cp -r "$skill" ~/.claude/skills
    done
    echo "✅ Done."
fi



echo "All done. Now restart your shell or run \`source ~/.bashrc\`"
