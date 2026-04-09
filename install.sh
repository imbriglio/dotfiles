#!/bin/bash

# --- 1. CORE PERFORMANCE TOOLS ---
sudo apt-get update && sudo apt-get install -y \
    btop htop jq ripgrep fd-find python3-pip python3-venv \
    postgresql-client redis-tools

# --- 2. NODE & CLAUDE (The Brain) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Upgrade to Node 20 for TransformStream support
nvm install 20 && nvm use 20 && nvm alias default 20

# Install Claude, PNPM (faster than npm), and Vite
npm install -g @anthropic-ai/claude-code pnpm vite

# --- 3. JAVA & BUILD TOOLS (The Muscle) ---
if [[ ! -d "$HOME/.sdkman" ]]; then
    curl -s "https://get.sdkman.io" | bash
fi
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Java 21 is the 2026 standard for performance
sdk install java 21.0.2-amzn < /dev/null
sdk install gradle < /dev/null
sdk install jmeter < /dev/null

# --- 4. GITHUB MASTER ACCESS (The Plumbing) ---
# Uses the Secret you set in GitHub Settings
if [ -n "$GH_TOKEN_MASTER" ]; then
    git config --global credential.helper "! f() { echo \"username=git\"; echo \"password=${GH_TOKEN_MASTER}\"; }; f"
fi

# --- 5. ALIASES & SHELL (The Experience) ---
cat << 'EOF' >> ~/.zshrc

# Claude & UI
alias c='claude'
alias v='pnpm vite'
alias create-app='pnpm create vite'

# Performance & Java
alias jpsv='jps -v'
alias mem='free -h -t'
alias cpu='btop'

# Trading / Market Time
alias market='TZ="America/New_York" date'

# Git "Senior" Graph
alias adog="git log --all --decorate --oneline --graph"

# Railway CLI (Assuming you've logged in once)
alias r-deploy='railway up'
alias r-logs='railway logs'
alias r-vars='railway variables'
EOF

source ~/.zshrc
echo "--- ARCHITECT ENVIRONMENT READY ---"
