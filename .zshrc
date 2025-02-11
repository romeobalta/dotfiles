export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"
export SPACESHIP_CONFIG="$HOME/.config/spaceship.zsh"

HIST_STAMPS="dd/mm/yyyy"

plugins=(
    dotenv
    node
    web-search
    colored-man-pages
    common-aliases
)

source $ZSH/oh-my-zsh.sh

# User configuration
export TERM=xterm-ghostty
export EDITOR='nvim'

source ~/.config/aliases.zsh
source ~/.config/binds.zsh
source ~/.config/fn.zsh
source ~/.config/path.zsh
source ~/.config/fzf.zsh
[ -s ~/.zshrc_custom ] && source ~/.zshrc_custom # source ~/.zshrc_custom only if it exists


# Programs and other stuff
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
