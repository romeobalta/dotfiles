-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
local g = vim.g

-------------------------------------- options ------------------------------------------
opt.laststatus = 3 -- global statusline
opt.showmode = false

-- opt.relativenumber = false

-- disable nvim intro
-- opt.shortmess:append("sI")

-- opt.swapfile = false
-- opt.backup = false

opt.scrolloff = 8
opt.colorcolumn = "100"

-- opt.wrap = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

g.copilot_no_maps = true
