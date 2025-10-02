alias ga='git add'
alias gr='git rm'
alias gd='git diff'
alias gco='git checkout'
alias push='git push'
alias pull='git pull'
alias fetch='git fetch'
alias gs='git status'
alias gc='git commit'
alias gcm='git commit -m'
alias gb='git branch'
alias ll='ls -alh'
alias dotfiles='cd $HOME/dotfiles'

alias soundrestart='sudo launchctl stop com.apple.audio.coreaudiod && sudo launchctl start com.apple.audio.coreaudiod'
alias dcu='docker compose up'
alias dcd='docker compose down'

alias nosleep='caffeinate -disu &'

alias gitchanges='git --no-pager diff --name-only FETCH_HEAD $(git merge-base FETCH_HEAD master)'

# zig
alias zb='zig build'
alias zr='zig run'
alias zt='zig test'
alias zbr='zig build run'
alias zbt='zig build test --summary all'
alias zd='zig-dev'
alias zs='zig-stable'
alias zf='zig fetch'
alias zfs='zig fetch --save'

# nix
alias ns="nix-shell"

# nvim
alias vim='nvim'
alias nvim-own='NVIM_APPNAME="nvim-own" nvim'

alias claude="~/.claude/local/claude"
