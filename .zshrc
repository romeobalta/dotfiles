export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"
export SPACESHIP_CONFIG="$HOME/.config/spaceship.zsh"

HIST_STAMPS="yyyy-mm-dd"

plugins=(
    dotenv
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
[ -s ~/.config/fn_custom.zsh ] && source ~/.config/fn_custom.zsh
