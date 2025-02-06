-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

-- g.lazyvim_picker = "snacks"
opt.guicursor = ""

g.snacks_animate = false
g.mapleader = " "
g.maplocalleader = " "

g.copilot_no_maps = true

-------------------------------------- options ------------------------------------------
opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.tabstop = 8
opt.softtabstop = 8
opt.shiftwidth = 4

-- disable nvim intro
-- opt.shortmess:append("sI")

-- opt.swapfile = false
-- opt.backup = false

opt.scrolloff = 24
opt.colorcolumn = "100"

-- opt.wrap = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25
