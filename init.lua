local cmd = vim.cmd
local opt = vim.opt
local u = require('own.utils')

vim.g.mapleader = ' '
vim.g.vimsyn_embed = 'lPr'

require('own.plugins')

require('own.lsp')

require('own.telescope')

require('own.startify')

require('own.compe')

cmd([[
  set nohlsearch

  nnoremap <silent> <C-n> :NvimTreeToggle<CR>

  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exec 'noremap' key '<Nop>'
    exec 'inoremap' key '<Nop>'
    exec 'cnoremap' key '<Nop>'
  endfor

  set shortmess+=c
]])

opt.termguicolors = true

-------------------------
-- Indentation
-------------------------
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.smartindent = true
opt.smarttab = true
opt.autoindent = true

-------------------------
-- Display
-------------------------
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.signcolumn = 'yes'
opt.cursorline = true
opt.wrap = true
opt.linebreak = true
opt.incsearch = true
opt.hlsearch = false

opt.hidden = true
opt.splitbelow = true
opt.splitright = true

opt.background = 'dark'

-------------------------
-- Backup
-------------------------
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.confirm = true

-------------------------
-- Misc
-------------------------
opt.scrolloff = 8
opt.iskeyword:prepend { '-' }
opt.mouse = 'a'
opt.ruler = true
opt.completeopt = { 'menuone', 'noselect' }
opt.clipboard = 'unnamedplus'
opt.inccommand = 'nosplit'

-------------------------
-- Wild
-------------------------
opt.wildoptions = 'pum'
opt.pumblend = 7
opt.pumheight = 20

