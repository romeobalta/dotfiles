-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")

vim.keymap.set("i", "<C-b>", "<ESC>^i", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Escape insert mode", nowait = true })

-- Normal mode mappings
vim.keymap.set("n", "<Esc>", ":noh <CR>", { desc = "Clear highlights", silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-s>", "<ESC><cmd> w<CR>", { desc = "Exit insert mode and save", noremap = true })
vim.keymap.set("n", "<C-c>", "<cmd> %y+ <CR>", { desc = "Copy whole file" })

-- Movement mappings that handle wrapped lines
vim.keymap.set("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
vim.keymap.set("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
vim.keymap.set("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
vim.keymap.set("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })

-- Other mappings
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", { desc = "New buffer" })
vim.keymap.set("n", "<leader>ch", "<cmd> NvCheatsheet <CR>", { desc = "Mapping cheatsheet" })

vim.keymap.set("n", "<leader>fr", ":%s/", { desc = " enter search and replace", nowait = true })
vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "window operations", nowait = true })
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "toggle zen mode" })

vim.keymap.set("n", "<leader>a", function()
  vim.go.operatorfunc = "v:lua.append"
  vim.api.nvim_feedkeys("g@", "n", false)
end, { desc = "append in block", silent = true })

vim.keymap.set("n", "<leader>i", function()
  vim.go.operatorfunc = "v:lua.prepend"
  vim.api.nvim_feedkeys("g@", "n", false)
end, { desc = "prepend in block", silent = true })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "next search" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "prev search" })
vim.keymap.set("n", "Q", "<nop>", { desc = "disable ex mode" })
vim.keymap.set("n", "{", "<C-u>zz", { desc = "scroll up" })
vim.keymap.set("n", "}", "<C-d>zz", { desc = "scroll down" })

-- Visual mode mappings
vim.keymap.set("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
vim.keymap.set("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
vim.keymap.set("v", "y", "ygv<ESC>", { desc = "Yank then go at the end of the block", noremap = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down", noremap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up", noremap = true })

-- Select (visual block) mode mappings
vim.keymap.set(
  "x",
  "j",
  'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
  { desc = "Move down", expr = true, silent = true }
)
vim.keymap.set(
  "x",
  "k",
  'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
  { desc = "Move up", expr = true, silent = true }
)
vim.keymap.set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Do not copy replaced text", silent = true })

vim.keymap.set("n", "<leader>fgs", function()
  Util.terminal({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false })
end, { desc = "Lazygit (cwd)" })

vim.keymap.set({ "n", "v" }, "<leader>fm", function()
  Util.format({ force = true })
end, { desc = "Format" })
