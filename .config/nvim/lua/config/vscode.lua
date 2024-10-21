local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.opt.clipboard = "unnamedplus"

-- remap leader key
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- yank to system clipboard
keymap({ "n", "v" }, "y", '"+y', opts)

-- paste from system clipboard
keymap({ "n", "v" }, "p", '"+p', opts)

-- better indent handling
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- move text up and down
keymap("v", "J", ":m .+1<CR>==", opts)
keymap("v", "K", ":m .-2<CR>==", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- paste preserves primal yanked piece
keymap("v", "p", '"_dP', opts)

-- removes highlighting after escaping vim search
keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)

-- own navigation
keymap("n", "{", "<C-u>zz", { desc = "scroll up" })
keymap("n", "}", "<C-d>zz", { desc = "scroll down" })
keymap("n", "n", "nzzzv", { desc = "next search" })
keymap("n", "N", "Nzzzv", { desc = "prev search" })

-- vscode
local vscode = require("vscode")

-- general keymaps
keymap({ "n", "x" }, "<leader>gt", "<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>")
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
