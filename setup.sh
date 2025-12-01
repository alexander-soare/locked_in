#!/bin/bash

set -e

WORK=0

while [[ $# -gt 0 ]]; do
    case $1 in
    --work)
        WORK=1
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

# Check if git is installed, and if not, install it.
if ! command -v git &> /dev/null
then
    echo "⚙️  git could not be found, installing git..."
    sudo apt update
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
if command -v nvidia-smi &> /dev/null
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

# AWS
if [ $WORK -eq 1 ] && ( ! command -v aws >/dev/null 2>&1 || ! aws --version | grep -q 'aws-cli/2' ); then
    echo "⚙️  aws-cli v2 could not be found, installing aws-cli v2..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --update
    rm -rf awscliv2.zip aws
    echo "✅ Done."
fi

echo "All done. Now restart your shell or run \`source ~/.bashrc\`"
