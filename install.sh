#!/bin/zsh

sudo apt-get update && sudo apt-get install -y curl build-essential

if ! command -v railway >/dev/null; then
    sh -c "$(curl -sSL https://raw.githubusercontent.com/railwayapp/cli/master/install.sh)"
fi

if ! command -v claude >/dev/null; then
    npm install -g @anthropic-ai/claude-code
fi

if ! command -v starship >/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

ln -sf $(pwd)/.zshrc ~/.zshrc
ln -sf $(pwd)/.gitconfig ~/.gitconfig
