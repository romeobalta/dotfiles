" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

  " Better Syntax Support
  Plug 'sheerun/vim-polyglot'
  " Auto pairs for '(' '[' '{'
  Plug 'jiangmiao/auto-pairs'
  " Dracula theme
  Plug 'dracula/vim', { 'as': 'dracula' }

  " Telescope
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'

  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'hrsh7th/nvim-compe'
  " Plug 'nvim-lua/completion-nvim'
  
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

  Plug 'kyazdani42/nvim-web-devicons'

  Plug 'vim-airline/vim-airline'
  " vcug 'vim-airline/vim-airline-themes'
  
  Plug 'preservim/nerdtree'

  Plug 'ryanoasis/vim-devicons'

  Plug 'mhinz/vim-startify'
call plug#end()

colorscheme dracula
highlight Normal guibg=none
