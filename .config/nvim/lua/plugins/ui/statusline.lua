local M = {}

M.git_signs = {
	{ name = "added", sign = "+", hl = "MiniStatuslineDevinfoGitAdded" },
	{ name = "changed", sign = "~", hl = "MiniStatuslineDevinfoGitChanged" },
	{ name = "removed", sign = "-", hl = "MiniStatuslineDevinfoGitRemoved" },
}

M.diagnostic_levels = {
	{ name = "ERROR", sign = "E", hl = "MiniStatuslineDevinfoError" },
	{ name = "WARN", sign = "W", hl = "MiniStatuslineDevinfoWarn" },
	{ name = "INFO", sign = "I", hl = "MiniStatuslineDevinfoInfo" },
	{ name = "HINT", sign = "H", hl = "MiniStatuslineDevinfoHint" },
}

function M.statusline_active()
	local MiniStatusline = require("mini.statusline")
	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
	local git = MiniStatusline.section_git({ trunc_width = 40 })
	local diff = M.statusline_section_diff({ trunc_width = 75 })
	local diagnostics = M.statusline_section_diagnostics({ trunc_width = 75 })
	local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
	local filename = MiniStatusline.section_filename({ trunc_width = 140 })
	local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
	local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

	-- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
	-- correct padding with spaces between groups (accounts for 'missing'
	-- sections, etc.)
	return MiniStatusline.combine_groups({
		{ hl = mode_hl, strings = { mode } },
		{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
		"%<", -- Mark general truncate point
		{ hl = "MiniStatuslineFilename", strings = { filename } },
		"%=", -- End left alignment
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

	local icon = ""
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

	local summary = table.concat(t, "")

	local icon = ""
	return icon .. " " .. (summary == "" and "-" or summary) .. "%#MiniStatuslineDevinfo#"
end

require("mini.statusline").setup({
	content = {
		active = M.statusline_active,
	},
})
