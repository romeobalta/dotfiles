return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/lsp-status.nvim'
  use 'mhinz/vim-startify'

  use {
    'gelguy/wilder.nvim'
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'mhinz/vim-signify'
  }

  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function () require 'own.statusline' end,
    requires = {'kyazdani42/nvim-web-devicons'},
    event = 'VimEnter',
  }

  use {
	'nvim-lua/popup.nvim'
  }

  use {
	'nvim-lua/plenary.nvim'
  }

  use {
	'nvim-telescope/telescope.nvim'
  }

  use {
	'nvim-telescope/telescope-fzy-native.nvim'
  }

  use {
    'dracula/vim',
    as = 'dracula',
  }

  use {
    'nvim-treesitter/nvim-treesitter', 
    -- do = ':TSUpdate', 
  }
  
  use 'sheerun/vim-polyglot'
  use 'jiangmiao/auto-pairs'
  use 'neovim/nvim-lspconfig'
  use 'kabouzeid/nvim-lspinstall'
  use 'hrsh7th/nvim-compe'
  use 'kyazdani42/nvim-web-devicons'
  use 'ryanoasis/vim-devicons'
end)
