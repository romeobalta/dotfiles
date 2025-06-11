local M = {}

-- The state is now tracked by an augroup ID, not a job ID.
local augroup_id = nil
local AUGROUP_NAME = "ZigBuildOnSave"

local ERROR_PATTERN = "(.-%.zig):(%d+):(%d+):%s*error:%s*(.*)"

local function strip_ansi_codes(text)
	local clean_text = text:gsub("\27%[[;%d%?]*[a-zA-Z]", "")

	clean_text = clean_text:gsub("\27%(0[a-zA-Z]+\27%(B", "")
	clean_text = clean_text:gsub("\27M", "")
	clean_text = clean_text:gsub("\r", "")

	return clean_text
end

-- This new function runs a single build. It's called by the autocmd.
local function run_build()
	vim.notify("Starting Zig build...", vim.log.levels.INFO)
	vim.schedule(function()
		vim.cmd("cclose")
	end)

	-- The command no longer uses '--watch'.
	local command = {
		"zig",
		"build",
		"-fincremental",
		"--summary",
		"none",
	}

	vim.system(command, {
		text = true,
	}, function(res)
		-- split into new lines
		local data = (res.stderr or "")
		local matches = {}

		for line in data:gmatch("([^\r\n]*)[\r\n]?") do
			local clean_line = strip_ansi_codes(line)
			local path, ln, col, errorMessage = string.match(clean_line, ERROR_PATTERN)

			if path and ln and col and errorMessage then
				table.insert(matches, {
					text = errorMessage,
					filename = path,
					lnum = tonumber(ln),
					col = tonumber(col),
				})
			end
		end

		if #matches == 0 then
			vim.notify("Zig build successful.", vim.log.levels.INFO)
		elseif #matches > 0 then
			vim.notify("Build found " .. #matches .. " error(s). Check quickfix list.", vim.log.levels.ERROR)
			vim.schedule(function()
				vim.fn.setqflist({}, "r", {
					title = "Zig Build Errors",
					items = matches,
				})
				vim.cmd("copen")
			end)
		end
	end)
end

-- M.start now creates an autocommand group instead of a job.
function M.start()
	if augroup_id then
		vim.notify("Zig build-on-save is already active.", vim.log.levels.WARN)
		return
	end

	vim.notify("Activating Zig build-on-save...")

	-- Create a dedicated, clearable autocommand group.
	augroup_id = vim.api.nvim_create_augroup(AUGROUP_NAME, { clear = true })

	-- Create the autocommand that triggers the build on save.
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = augroup_id,
		pattern = "*.zig",
		callback = run_build,
	})
end

-- M.stop now removes the autocommand group.
function M.stop()
	if not augroup_id then
		vim.notify("Zig build-on-save is not active.", vim.log.levels.WARN)
		return
	end

	vim.notify("Deactivating Zig build-on-save...")

	-- Clear the autocommands and delete the group.
	vim.api.nvim_clear_autocmds({ group = AUGROUP_NAME })
	augroup_id = nil
end

function M.is_running()
	return augroup_id ~= nil
end

function M.toggle()
	if M.is_running() then
		M.stop()
	else
		M.start()
	end
end

return M
