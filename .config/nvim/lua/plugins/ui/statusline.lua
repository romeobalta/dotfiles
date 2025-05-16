local M = {
	git_signs = {
		{ name = "added", sign = "+", hl = "MiniStatuslineDevinfoGitAdded" },
		{ name = "changed", sign = "~", hl = "MiniStatuslineDevinfoGitChanged" },
		{ name = "removed", sign = "-", hl = "MiniStatuslineDevinfoGitRemoved" },
	},
	diagnostic_levels = {
		{ name = "ERROR", sign = "E", hl = "MiniStatuslineDevinfoError" },
		{ name = "WARN", sign = "W", hl = "MiniStatuslineDevinfoWarn" },
		{ name = "INFO", sign = "I", hl = "MiniStatuslineDevinfoInfo" },
		{ name = "HINT", sign = "H", hl = "MiniStatuslineDevinfoHint" },
	},
}

local H = {}

function M.statusline_active()
	local MiniStatusline = require("mini.statusline")
	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
	local git = MiniStatusline.section_git({ trunc_width = 40 })
	local diff = M.statusline_section_diff({ trunc_width = 75 })
	local diagnostics = M.statusline_section_diagnostics({ trunc_width = 75 })
	local lsp = M.section_lsp({ trunc_width = 75 })
	local filename = M.section_filename({ trunc_width = 140 })
	local fileinfo = M.section_fileinfo({ trunc_width = 120, icon = "" })
	local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

	-- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
	-- correct padding with spaces between groups (accounts for 'missing'
	-- sections, etc.)
	return MiniStatusline.combine_groups({
		{ hl = mode_hl, strings = { mode } },
		{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
		"%<", -- Mark general truncate point
		{ hl = "MiniStatuslineFilename", strings = { filename } },
		"%=", -- End left alignment
		{ hl = "MiniStatuslineDevinfo", strings = { lsp } },
		{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
		{ hl = mode_hl, strings = { search } },
	})
end

---@param args __statusline_args
---@return __statusline_section
function M.statusline_section_diagnostics(args)
	local MiniStatusline = require("mini.statusline")

	if MiniStatusline.is_truncated(args.trunc_width) then
		return ""
	end

	-- Construct string parts
	local count = vim.diagnostic.count(0)
	local severity, signs, t = vim.diagnostic.severity, args.signs or {}, {}
	for _, level in ipairs(M.diagnostic_levels) do
		local n = count[severity[level.name]] or 0
		-- Add level info only if diagnostic is present
		if n > 0 then
			table.insert(t, " %#" .. level.hl .. "#" .. (signs[level.name] or level.sign) .. n)
		end
	end
	if #t == 0 then
		return ""
	end

	local icon = ""
	return icon .. table.concat(t, "") .. "%#MiniStatuslineDevinfo#"
end

---@param args __statusline_args
---@return __statusline_section
function M.statusline_section_diff(args)
	local MiniStatusline = require("mini.statusline")
	if MiniStatusline.is_truncated(args.trunc_width) then
		return ""
	end

	local info, t = vim.b.gitsigns_status_dict or {}, {}
	for _, sign in ipairs(M.git_signs) do
		local n = info[sign.name] or 0
		if n > 0 then
			table.insert(t, " %#" .. sign.hl .. "#" .. sign.sign .. n)
		end
	end

	local summary = vim.trim(table.concat(t, ""))

	local icon = ""
	return icon .. " " .. (summary == "" and "-" or summary) .. "%#MiniStatuslineDevinfo#"
end

---@param args __statusline_args
---@return __statusline_section
M.section_lsp = function(args)
	local MiniStatusline = require("mini.statusline")
	if MiniStatusline.is_truncated(args.trunc_width) then
		return ""
	end

	local t = {}
	local icons = require("config").icons.lsp

	for _, client in ipairs(Util.lsp.get_clients({ bufnr = 0 })) do
		local icon = icons[client.name] or " "
		if icon ~= nil then
			table.insert(t, icon)
		end
	end

	local attached = vim.trim(table.concat(t, ""))

	return "%#MiniStatuslineTitle#LSP: %#MiniStatuslineDevinfo#" .. (attached == "" and "-" or attached)
end

H.get_filesize = function()
	local size = vim.fn.getfsize(vim.fn.getreg("%"))
	if size < 1024 then
		return string.format("%dB", size)
	elseif size < 1048576 then
		return string.format("%.2fKiB", size / 1024)
	else
		return string.format("%.2fMiB", size / 1048576)
	end
end

---@param args __statusline_args
---@return __statusline_section
M.section_fileinfo = function(args)
	local MiniStatusline = require("mini.statusline")
	local filetype = vim.bo.filetype

	-- Don't show anything if there is no filetype
	if filetype == "" then
		return ""
	end

	-- Add filetype icon
	-- local get_icon = function(ft)
	-- 	return (require("mini.icons").get("filetype", ft))
	-- end
	filetype = filetype

	-- Construct output string if truncated or buffer is not normal
	if MiniStatusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= "" then
		return filetype
	end

	-- Construct output string with extra file info
	local encoding = vim.bo.fileencoding or vim.bo.encoding
	local format = vim.bo.fileformat
	local size = H.get_filesize()

	local fileinfo = string.format("%s %s[%s] %s", filetype, encoding, format, size)
	return "%#MiniStatuslineTitle#File: %#MiniStatuslineDevinfo#" .. fileinfo
end

---@param args __statusline_args
---@return __statusline_section
M.section_filename = function(args)
	local MiniStatusline = require("mini.statusline")

	-- In terminal always use plain name
	if vim.bo.buftype == "terminal" then
		return "%t"
	elseif vim.bo.filetype == "oil" then
		local bufnr = vim.api.nvim_get_current_buf()
		local ok, oil = pcall(require, "oil")
		if ok then
			local dir = oil.get_current_dir(bufnr)
			if dir then
				return vim.fn.fnamemodify(dir, ":~")
			end
		else
			return vim.api.nvim_buf_get_name(0)
		end
	elseif MiniStatusline.is_truncated(args.trunc_width) then
		-- File name with 'truncate', 'modified', 'readonly' flags
		-- Use relative path if truncated
		return "%f%m%r"
	else
		-- Use fullpath if not truncated
		return "%F%m%r"
	end

	return ""
end

require("mini.statusline").setup({
	content = {
		active = M.statusline_active,
	},
})
