#!/bin/bash

# --- 1. CORE PERFORMANCE TOOLS ---
echo "--- Installing Core Utils ---"
sudo apt-get update && sudo apt-get install -y \
    btop htop jq ripgrep fd-find python3-pip python3-venv \
    postgresql-client redis-tools

# --- 2. NODE & CLAUDE (Hardened NVM Logic) ---
echo "--- Setting up Node 20 & Claude ---"
# Codespaces default NVM path
export NVM_DIR="/usr/local/share/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# If NVM is found, install Node 20 (Required for Claude's TransformStream)
if command -v nvm &> /dev/null; then
    nvm install 20
    nvm use 20
    nvm alias default 20
    
    # Now install the tools with the fresh Node version
    npm install -g @anthropic-ai/claude-code pnpm vite
else
    echo "ERROR: NVM not found at $NVM_DIR. Falling back to system node."
    npm install -g @anthropic-ai/claude-code pnpm vite
fi

# --- 3. JAVA & BUILD TOOLS (SDKMAN) ---
echo "--- Setting up Java Stack ---"
if [[ ! -d "$HOME/.sdkman" ]]; then
    curl -s "https://get.sdkman.io" | bash
fi
# Source SDKMAN for the current session
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Non-interactive installs
sdk install java 21.0.2-amzn < /dev/null
sdk install gradle < /dev/null
sdk install jmeter < /dev/null

# --- 4. GITHUB MASTER ACCESS ---
if [ -n "$GH_TOKEN_MASTER" ]; then
    git config --global credential.helper "! f() { echo \"username=git\"; echo \"password=${GH_TOKEN_MASTER}\"; }; f"
fi

# --- 5. PERSISTENT ALIASES ---
# We write these to .bashrc AND .zshrc to be safe
cat << 'EOF' >> ~/.zshrc

# Tooling Aliases
alias c='claude'
alias v='pnpm vite'
alias jpsv='jps -v'
alias cpu='btop'
alias market='TZ="America/New_York" date'
alias adog="git log --all --decorate --oneline --graph"

# Auto-load NVM/SDKMAN for every new shell
export NVM_DIR="/usr/local/share/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
EOF

echo "--- ARCHITECT ENVIRONMENT READY ---"
