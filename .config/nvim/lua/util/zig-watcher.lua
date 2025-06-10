local M = {}

local job_id = nil

local SKIP_PATTERN = "\r\27M\27%[%?2026l"
local RESET_PATTERNS = {
	"Change Detected",
	"zig build-exe",
}
local ERROR_PATTERN = "(.-%.zig):(%d+):(%d+):%s*error:%s*(.*)"

local function strip_ansi_codes(text)
	local clean_text = text:gsub("\27%[[;%d%?]*[a-zA-Z]", "")

	clean_text = clean_text:gsub("\27%(0[a-zA-Z]+\27%(B", "")
	clean_text = clean_text:gsub("\27M", "")
	clean_text = clean_text:gsub("\r", "")

	return clean_text
end

function M.start(opts)
	opts = opts or {}

	if job_id then
		vim.notify("Zig watcher is already running.", vim.log.levels.WARN)
		return
	end

	local command = {
		"zig",
		"build",
		"-fincremental",
		"--watch",
		"--summary",
		"none",
	}

	vim.notify("Starting Zig watcher...")

	local new_build = false

	job_id = vim.fn.jobstart(command, {
		pty = true,
		on_stdout = function(_, data, _)
			local matches = {}
			for _, line in ipairs(data) do
				local start_pos = string.find(line, SKIP_PATTERN)
				if start_pos then
					goto continue
				end

				for _, reset_pattern in ipairs(RESET_PATTERNS) do
					if line ~= "" and string.match(line, reset_pattern) then
						matches = {}
						vim.fn.setqflist({}, "r")

						new_build = true

						goto after_reset
					end
				end
				::after_reset::

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

				::continue::
			end

			if #matches == 0 and new_build then
				vim.notify("Zig build successful.", vim.log.levels.INFO)
			end

			if #matches > 0 then
				vim.fn.setqflist({}, " ", { title = "Zig Watch Errors", items = matches })
				vim.notify("Build found " .. #matches .. " error(s). Check quickfix list.", vim.log.levels.ERROR)
			end
			new_build = false
		end,

		on_stderr = function(_, data, _)
			for _, line in ipairs(data) do
				if line ~= "" then
					vim.notify("[Zig STDERR]: " .. line, vim.log.levels.WARN)
				end
			end
		end,

		on_exit = function(_, code, _)
			job_id = nil
			local level = (code == 0) and vim.log.levels.INFO
			vim.notify("Zig watcher stopped. Exit code (" .. tostring(code) .. ")", level)
		end,
	})

	if not job_id or job_id == 0 or job_id == -1 then
		vim.notify("Failed to start Zig watcher.", vim.log.levels.ERROR)
		job_id = nil
	end
end

function M.stop()
	if not job_id then
		vim.notify("Zig watcher is not running.", vim.log.levels.WARN)
		return
	end

	vim.notify("Stopping Zig watcher...")
	vim.fn.jobstop(job_id)
	job_id = nil
end

function M.is_running()
	return job_id ~= nil
end

function M.toggle()
	if M.is_running() then
		M.stop()
	else
		M.start()
	end
end

return M
