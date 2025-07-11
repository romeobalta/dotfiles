local map = vim.keymap.set

map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<Esc>", ":noh <CR>", { desc = "Clear highlights", silent = true })
map("n", "<C-c>", "<cmd> %y+ <CR>", { desc = "Copy whole file" })
map("n", "Q", "<nop>", { desc = "disable ex mode" })
map("v", "y", "ygv<ESC>", { desc = "Yank then go at the end of the block", noremap = true })
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Do not copy replaced text", silent = true })

map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-----------------------
-- Netrw
-----------------------
-- map("n", "<leader>e", vim.cmd.Ex)
-- map("n", "<leader>r", vim.cmd.Rex)

-----------------------
-- File utilities
-----------------------
map("n", "<leader>fu", "", { desc = "File utilities" })

---Return current buffer path using filename modifier.
---@param mod string See |filename-modifiers|
local function get_location(mod)
	local location = ""

	if vim.bo.filetype == "oil" then
		local ok, oil = pcall(require, "oil")
		if ok then
			local bufnr = vim.api.nvim_get_current_buf()
			local dir = oil.get_current_dir(bufnr)
			if dir then
				location = dir
			end
		end
	else
		location = vim.api.nvim_buf_get_name(0)
	end

	return vim.fn.fnamemodify(location, mod)
end

-- Copy relative and full file path to clipboard
map("n", "<leader>fur", function()
	vim.fn.setreg("+", get_location(":."))
end, { desc = "Copy relative file path" })

map("n", "<leader>ful", function()
	vim.fn.setreg("+", get_location(":~"))
end, { desc = "Copy full file path" })

-----------------------
-- Window mappings
-----------------------
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

map("n", "<M->>", "<C-W>5>", { desc = "Increase window height" })
map("n", "<M-<>", "<C-W>5<", { desc = "Increase window height" })
map("n", "<M-+>", "<C-W>+", { desc = "Increase window height" })
map("n", "<M-->", "<C-W>-", { desc = "Increase window height" })

-----------------------
-- Movement mappings
-----------------------
map({ "n", "v" }, "{", "<C-u>zz", { desc = "scroll up" })
map({ "n", "v" }, "}", "<C-d>zz", { desc = "scroll down" })
map("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true, silent = true })
map("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true, silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Move lines up and down
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-----------------------
-- Util
-----------------------

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- better indenting reselect after indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- quickfix list
map("n", "<leader>k", function()
	local ok, _ = pcall(vim.api.nvim_command, "cprev")

	if not ok then
		Snacks.notify.error("No previous quickfix")
	end
end, { desc = "Previous Quickfix" })
map("n", "<leader>j", function()
	local ok, _ = pcall(vim.api.nvim_command, "cnext")

	if not ok then
		Snacks.notify.error("No next quickfix")
	end
end, { desc = "Next Quickfix" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- toggle wrap
map("n", "<leader>uw", function()
	local wrap = vim.wo.wrap
	vim.wo.wrap = not wrap
end, { desc = "Inspect Tree" })

------------------------------
---These should move
------------------------------

map("n", "<leader>wz", function()
	---@diagnostic disable-next-line: missing-fields
	require("snacks").zen.zen({
		window = {
			width = 130, -- width will be 85% of the editor width
		},
	})
end)
