SOFT_DIR="${HOME}/soft"

# go
export GOPATH=$HOME/.go
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/.local/bin/scripts:$PATH"

export LESS='-FRX'
export RUST_BACKTRACE=1

# nvim
NVIM_DIR="${SOFT_DIR}/nvim-macos-arm64/bin"
if [ -d "$NVIM_DIR" ]; then
    # Check if it's already in PATH to avoid duplicates
    case ":$PATH:" in
        *":$NVIM_DIR:"*) ;;
        *) export PATH="$NVIM_DIR:$PATH" ;;
    esac
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"

# zig
ZIG_VERSION="zig-0.14.1"
ZIG_DIR="${SOFT_DIR}/${ZIG_VERSION}"
ZIG_DEV_DIR="${HOME}/soft/zig/build/stage3/bin"
if [ -d "$ZIG_DEV_DIR" ]; then
    case ":$PATH:" in
        *":$ZIG_DEV_DIR:"*) ;;
        *) export PATH="$ZIG_DEV_DIR:$PATH" ;;
    esac
fi

ZLS_DIR="${SOFT_DIR}/zls/zig-out/bin"
ZLS_DEV_DIR="${SOFT_DIR}/zls-dev/zig-out/bin"
if [ -d "$ZLS_DEV_DIR" ]; then
    # Check if it's already in PATH to avoid duplicates
    case ":$PATH:" in
        *":$ZLS_DEV_DIR:"*) ;;
        *) export PATH="$ZLS_DEV_DIR:$PATH" ;;
    esac
fi

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# pnpm
export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# kubectl
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
