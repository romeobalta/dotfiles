-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- delete lazyvim keymaps
-- vim.keymap.del("n", "<leader>ft")
-- vim.keymap.del("n", "<leader>fT")
-- vim.keymap.del("n", "<leader>ww")
-- vim.keymap.del("n", "<leader>wd")
-- vim.keymap.del("n", "<leader>w-")
-- vim.keymap.del("n", "<leader>w|")

local Util = require("lazyvim.util")

vim.keymap.set("i", "<C-b>", "<ESC>^i", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Escape insert mode", nowait = true })

-- Normal mode mappings
vim.keymap.set("n", "<Esc>", ":noh <CR>", { desc = "Clear highlights", silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<C-s>", "<ESC><cmd> w<CR>", { desc = "Exit insert mode and save", noremap = true })
vim.keymap.set("n", "<C-c>", "<cmd> %y+ <CR>", { desc = "Copy whole file" })

-- Movement mappings that handle wrapped lines
vim.keymap.set("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
vim.keymap.set("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
vim.keymap.set("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
vim.keymap.set("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })

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

-- Util mappings
vim.keymap.set("n", "<C-g>", function()
  Util.terminal({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false })
end, { desc = "Lazygit (cwd)" })

vim.keymap.set({ "n", "v" }, "<leader>fm", function()
  Util.format({ force = true })
end, { desc = "Format" })

-- Copilot and LuaSnip integration
-- vim.keymap.set("i", "<tab>", function()
--   local copilot_suggestion = require("copilot.suggestion")
--   if require("luasnip").jumpable(1) then
--     require("luasnip").jump(1)
--   elseif copilot_suggestion.is_visible() then
--     require("copilot.suggestion").accept()
--   else
--     vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
--   end
-- end, { desc = "LuaSnip jump or Copilot autocomplete or Tab" })

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

if vim.g.vscode then
  local keymap = vim.keymap.set
  local vscode = require("vscode")

  -- general keymaps
  keymap(
    { "n", "x" },
    "<leader>gt",
    "<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>"
  )
  keymap({ "n", "x" }, "<leader>gb", "<cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>")

  keymap({ "n", "x" }, "<leader>ca", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>")
  keymap({ "n", "x" }, "<leader>cA", "<cmd>lua require('vscode').action('editor.action.sourceAction')<CR>")
  keymap({ "n", "x" }, "<leader>cr", "<cmd>lua require('vscode').action('editor.action.rename')<CR>")
  keymap({ "n", "x" }, "<leader>cR", function()
    vscode.action("editor.action.refactor")
  end)
  keymap({ "n", "x" }, "<leader>rf", function()
    vscode.with_insert(function()
      vscode.action("editor.action.refactor")
    end)
  end)

  keymap({ "n", "v" }, "<leader>cn", "<cmd>lua require('vscode').action('notifications.clearAll')<CR>")

  keymap({ "n", "v" }, "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>")
  keymap({ "n", "v" }, "<leader>cp", "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>")
  keymap({ "n", "v" }, "<leader>pr", "<cmd>lua require('vscode').action('code-runner.run')<CR>")
  keymap({ "n", "v" }, "<leader>fm", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")

  -- harpoon keymaps
  keymap({ "n", "v" }, "<leader>ma", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>")
  keymap({ "n", "v" }, "<leader>fb", "<cmd>lua require('vscode').action('vscode-harpoon.editorQuickPick')<CR>")
  keymap({ "n", "v" }, "<leader>me", "<cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>")
  keymap({ "n", "v" }, "<leader>1", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor1')<CR>")
  keymap({ "n", "v" }, "<leader>2", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor2')<CR>")
  keymap({ "n", "v" }, "<leader>3", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor3')<CR>")
  keymap({ "n", "v" }, "<leader>4", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor4')<CR>")
  keymap({ "n", "v" }, "<leader>5", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor5')<CR>")
  keymap({ "n", "v" }, "<leader>6", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor6')<CR>")
  keymap({ "n", "v" }, "<leader>7", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor7')<CR>")
  keymap({ "n", "v" }, "<leader>8", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor8')<CR>")
  keymap({ "n", "v" }, "<leader>9", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor9')<CR>")

  -- project manager keymaps
  keymap({ "n", "v" }, "<leader>pa", "<cmd>lua require('vscode').action('projectManager.saveProject')<CR>")
  keymap({ "n", "v" }, "<leader>po", "<cmd>lua require('vscode').action('projectManager.listProjects')<CR>")
  keymap({ "n", "v" }, "<leader>pe", "<cmd>lua require('vscode').action('projectManager.editProjects')<CR>")

  keymap({ "n" }, "]d", "<cmd>lua require('vscode').action('editor.action.marker.next')<CR>")
  keymap({ "n" }, "[d", "<cmd>lua require('vscode').action('editor.action.marker.prev')<CR>")

  keymap({ "n" }, "]g", "<cmd>lua require('vscode').action('workbench.action.editor.nextChange')<CR>")
  keymap({ "n" }, "[g", "<cmd>lua require('vscode').action('workbench.action.editor.previousChange')<CR>")
end
