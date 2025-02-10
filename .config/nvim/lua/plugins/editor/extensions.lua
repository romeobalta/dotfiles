---@class editor.extensions
---@field oil_restore_points RestorePoints
local M = {
	oil_restore_points = {},
}

---@alias RestorePoints table<number, editor.extensions.RestorePoint|nil>

---@class editor.extensions.RestorePoint
---@field filename string
---@field row number
---@field col number
---@field topline number

function M.ufo_fold_text(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local numLines = endLnum - lnum
	local word = numLines == 1 and "line" or "lines"
	local suffix = ("󰁂 %d " .. word):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { " ", "Folded" })
	table.insert(newVirtText, { suffix, "FoldedComment" })
	return newVirtText
end

function M.oil_get_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return vim.fn.fnamemodify(dir, ":~")
	else
		-- If there is no current directory (e.g. over ssh), just show the buffer name
		return vim.api.nvim_buf_get_name(0)
	end
end

-- the follwing code is some harpoon code repurposed to mimick the :Rex command for oil.nvim
local Path = require("plenary.path")
local function normalize_path(buf_name, root)
	return Path:new(buf_name):make_relative(root)
end

local function get_root_dir()
	return vim.uv.cwd()
end

local function to_exact_name(value)
	return "^" .. value .. "$"
end

function M.oil_Ex()
	local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

	-- we want to create a restore point only if it's a file
	if buf_name:sub(1, 4) ~= "oil:" then
		M.oil_create_restore_point()
	end

	vim.api.nvim_command("Oil")
end

function M.oil_create_restore_point()
	local filename = normalize_path(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), get_root_dir())

	local bufnr = vim.fn.bufnr(filename, false)
	local row, col = unpack({ 1, 0 })

	if bufnr ~= -1 then
		row, col = unpack(vim.api.nvim_win_get_cursor(0))
	end

	local topline = vim.fn.line("w0")

	local win = vim.api.nvim_get_current_win()

	M.oil_restore_points[win] = { filename = filename, row = row, col = col, topline = topline }
end

function M.oil_Rex()
	local win = vim.api.nvim_get_current_win()

	if M.oil_restore_points[win] == nil then
		Snacks.notify.warn("No restore point found")
		return
	end

	local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

	if buf_name:sub(1, 4) ~= "oil:" then
		Snacks.notify.warn("Not an oil buffer")
		return
	end

	---@type editor.extensions.RestorePoint
	local restore_point = M.oil_restore_points[win]
	local bufnr = vim.fn.bufnr(to_exact_name(restore_point.filename))

	local set_position = false
	if bufnr == -1 then -- must create a buffer!
		set_position = true
		bufnr = vim.fn.bufadd(restore_point.filename)
	end
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		vim.fn.bufload(bufnr)
		vim.api.nvim_set_option_value("buflisted", true, {
			buf = bufnr,
		})
	end

	vim.api.nvim_set_current_buf(bufnr)

	if set_position then
		local lines = vim.api.nvim_buf_line_count(bufnr)

		if restore_point.row > lines then
			restore_point.row = lines
		end

		local row = restore_point.row
		local row_text = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
		local col = #row_text[1]

		if restore_point.col > col then
			restore_point.col = col
		end

		vim.api.nvim_win_set_cursor(0, {
			restore_point.row or 1,
			restore_point.col or 0,
		})
	end

	-- set top line
	vim.fn.winrestview({
		topline = restore_point.topline,
	})
end

function M.harpoon_navigate_in_windows()
	return {
		SELECT = function(ev)
			local bufnr = vim.fn.bufnr(to_exact_name(ev.item.value))

			if bufnr == -1 then
				return
			end

			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_get_buf(win) == bufnr then
					vim.api.nvim_set_current_win(win)
					return
				end
			end
		end,
	}
end

local kind_filter = {
	default = {
		"Class",
		"Constant",
		"Constructor",
		"Enum",
		"Field",
		"Function",
		"Interface",
		"Method",
		"Module",
		"Namespace",
		"Package",
		"Property",
		"Struct",
		"Trait",
		"Variable",
	},
	markdown = false,
	help = false,
	-- you can specify a different filter for each filetype
	lua = {
		"Class",
		"Constant",
		"Constructor",
		"Enum",
		"Field",
		"Function",
		"Interface",
		"Method",
		"Module",
		"Namespace",
		-- "Package", -- remove package since luals uses it for control flow structures
		"Property",
		"Struct",
		"Trait",
		"Variable",
	},
}

function _G.fzf_open(command, opts)
	return function()
		opts = opts or {}
		if opts.cmd == nil and command == "git_files" and opts.show_untracked then
			opts.cmd = "git ls-files --exclude-standard --cached --others"
		end
		return require("fzf-lua")[command](opts)
	end
end

function M.fzf_symbols_filter(entry, ctx)
	local function get_kind_filter(buf)
		buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
		local ft = vim.bo[buf].filetype

		if kind_filter == false then
			return
		end

		if kind_filter[ft] == false then
			return
		end

		if type(kind_filter[ft]) == "table" then
			return kind_filter[ft]
		end
	end

	if ctx.symbols_filter == nil then
		ctx.symbols_filter = get_kind_filter(ctx.bufnr) or false
	end
	if ctx.symbols_filter == false then
		return true
	end
	return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

return M
