#!/usr/bin/env bash
#
# agys installer
# One-shot installation script for Antigravity Session Explorer
#
set -e

# Styling
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info() {
    echo -e "${BLUE}==>${NC} ${BOLD}$1${NC}"
}

success() {
    echo -e "${GREEN}✔${NC} $1"
}

warn() {
    echo -e "${YELLOW}▲${NC} $1"
}

error() {
    echo -e "${RED}✖${NC} $1" >&2
}

# 1. Check Python version
info "Checking system requirements..."

if ! command -v python3 &>/dev/null; then
    error "Python 3 is required but was not found. Please install Python 3.8+."
    exit 1
fi

PYTHON_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
PYTHON_MAJOR=$(python3 -c "import sys; print(sys.version_info.major)")
PYTHON_MINOR=$(python3 -c "import sys; print(sys.version_info.minor)")

if [ "$PYTHON_MAJOR" -lt 3 ] || { [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 8 ]; }; then
    error "Python 3.8+ is required (found $PYTHON_VER)."
    exit 1
fi
success "Found Python $PYTHON_VER"

# Check agy CLI presence (advisory)
if ! command -v agy &>/dev/null; then
    warn "The 'agy' CLI was not found in PATH. Make sure Google Antigravity is installed."
else
    success "Found Antigravity CLI ('agy')"
fi

# 2. Determine target install directory
INSTALL_DIR="${AGYS_INSTALL_DIR:-$HOME/.local/bin}"
mkdir -p "$INSTALL_DIR"

TARGET_BIN="$INSTALL_DIR/agys"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"

# 3. Install binary
info "Installing agys to $INSTALL_DIR..."

if [ -n "$SOURCE_DIR" ] && [ -f "$SOURCE_DIR/agys" ]; then
    # Local install from repository
    rm -f "$TARGET_BIN"
    cp "$SOURCE_DIR/agys" "$TARGET_BIN"
else
    # Remote install via curl | bash
    RAW_URL="${AGYS_SOURCE_URL:-https://raw.githubusercontent.com/your-username/agy-sessions/main/agys}"
    if [ "$RAW_URL" = "https://raw.githubusercontent.com/your-username/agy-sessions/main/agys" ] && [ -d .git ]; then
        REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null || true)
        if [[ "$REMOTE_URL" =~ github\.com[:/]([^/]+)/([^/.]+)(\.git)? ]]; then
            REPO_USER="${BASH_REMATCH[1]}"
            REPO_NAME="${BASH_REMATCH[2]}"
            RAW_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/main/agys"
        fi
    fi
    if command -v curl &>/dev/null; then
        curl -fsSL "$RAW_URL" -o "$TARGET_BIN"
    elif command -v wget &>/dev/null; then
        wget -qO "$TARGET_BIN" "$RAW_URL"
    else
        error "Neither curl nor wget found. Cannot download agys."
        exit 1
    fi
fi

chmod +x "$TARGET_BIN"
success "Installed executable to $TARGET_BIN"

# 4. PATH verification
PATH_CONFIGURED=false
case ":$PATH:" in
    *":$INSTALL_DIR:"*) PATH_CONFIGURED=true ;;
esac

echo ""
echo -e "${GREEN}${BOLD}Installation Complete! 🎉${NC}"
echo ""

if [ "$PATH_CONFIGURED" = true ]; then
    echo -e "You can now run:  ${BOLD}agys${NC}"
else
    warn "$INSTALL_DIR is not currently in your PATH."
    echo ""
    echo "To add it, append the following line to your shell profile (~/.zshrc or ~/.bashrc):"
    echo -e "  ${BOLD}export PATH=\"$INSTALL_DIR:\$PATH\"${NC}"
    echo ""
    echo "Then reload your shell:"
    echo -e "  ${BOLD}source ~/.zshrc${NC}  # or source ~/.bashrc"
    echo ""
    echo -e "Once reloaded, simply run:  ${BOLD}agys${NC}"
fi
echo ""
