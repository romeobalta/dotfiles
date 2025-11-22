local uv = vim.uv
local util = require("lspconfig.util")

local M = {}

local state = {}

local function get_zig_root()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" then
		return nil
	end

	local root = util.root_pattern("build.zig", ".git")(bufname)
	return root
end

function M.start()
	local root = get_zig_root()

	if not root then
		return
	end

	if state.artifact_watcher then
		return
	end

	state.artifact_watcher = uv.new_fs_event()
	local bin_dir = root .. "/zig-out/bin"

	local stat = uv.fs_stat(bin_dir)
	if not stat or stat.type ~= "directory" then
		-- no bin dir yet (maybe build never run) -> do nothing
		return
	end

	vim.notify("👀 Starting Zig artifact watcher on: " .. bin_dir)

	state.artifact_watcher:start(bin_dir, {}, function(err)
		if err then
			dd("Zig watcher error:", err)
			return
		end
		-- reset debounce timer
		if state.debounce_timer then
			state.debounce_timer:stop()
		else
			state.debounce_timer = uv.new_timer()
		end

		-- start or restart the timer
		state.debounce_timer:start(500, 0, function()
			vim.schedule(function()
				vim.notify("🔄 Zig artifacts updated")
			end)
		end)
	end)
end

return M
