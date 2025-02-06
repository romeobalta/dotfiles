local g = vim.g
local opt = vim.opt

g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25

g.mapleader = " "
g.maplocalleader = " "

g.snacks_animate = false
g.copilot_no_maps = true -- no copilot maps

opt.guicursor = "n-v-c:block"

opt.autowrite = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.confirm = true
opt.expandtab = true
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.formatexpr = "v:lua.require'util'.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 3
opt.linebreak = true
opt.list = true
opt.listchars = "tab:> ,trail:-,nbsp:+"
opt.mouse = "a"
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.pumblend = 10
opt.pumheight = 10
opt.scrolloff = 16
opt.sessionoptions = { "buffers", "curdir", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true
opt.shiftwidth = 4
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.statuscolumn = [[%!v:lua.require'plugins.editor.statuscolumn'.get()]]
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.smoothscroll = true
opt.foldmethod = "expr"
opt.foldtext = ""
opt.foldexpr = "v:lua.require'util'.foldexpr()"
opt.foldlevel = 99
opt.wrap = false
