local M = {}

M.custom = {
	n = {
		["<leader>bd"] = { "<cmd> :bp | bd# <CR>", "close current buffer", opts = {} },
		["P"] = { '"0p', "paste yanked not deleted", opts = {} },
    ["<A-k>"] = { "<cmd> :MoveLine(-1)<CR>", "move line down", opts = { noremap = true, silent = true } },
		["<A-j>"] = { "<cmd> :MoveLine(1)<CR>", "move line up", opts = { noremap = true, silent = true } },
    ["<A-Up>"] = { "<cmd> :MoveLine(-1)<CR>", "move line up", opts = { noremap = true, silent = true } },
		["<A-Down>"] = { "<cmd> :MoveLine(1)<CR>", "move line down", opts = { noremap = true, silent = true } },
	},

	i = {
		["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } },
	},

	v = {
    ["<A-k>"] = { "<cmd> :MoveBlock(-1)<CR>", "move line down", opts = { noremap = true, silent = true } },
		["<A-j>"] = { "<cmd> :MoveBlock(1)<CR>", "move line up", opts = { noremap = true, silent = true } },
		["<A-Up>"] = { "<cmd> :MoveBlock(-1)<CR>", "move line up", opts = { noremap = true, silent = true } },
		["<A-Down>"] = { "<cmd> :MoveBlock(1)<CR>", "move line down", opts = { noremap = true, silent = true } },
	},
}

return M
