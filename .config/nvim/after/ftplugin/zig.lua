local zig_watcher = require("util.zig-watcher")

local build_notifier = nil
local pid = nil

local function close_terminal_window()
	if build_notifier then
		vim.api.nvim_win_close(build_notifier, true)
		build_notifier = nil
	end
end

---Open a terminal window with the given stdout and stderr
---@param cmd string The command to run
---@param args string[] The arguments to pass to the command
local function run_in_terminal_window(cmd, args)
	local buf = vim.api.nvim_create_buf(false, true)
	local height = math.min(15, math.floor(vim.o.lines * 0.8))

	-- If we close the window, we need to set the global variable to nil
	vim.api.nvim_create_autocmd({ "BufHidden" }, {
		buffer = buf,
        once = true,
		callback = function()
			if pid then
				-- Kill the process if it is still running
				vim.schedule(function()
					vim.uv.kill(-pid, 15)
                    pid = nil
				end)
			end
			build_notifier = nil
		end,
	})

	-- Close the terminal window if it's already open
	close_terminal_window()

	build_notifier = vim.api.nvim_open_win(buf, true, {
		split = "below",
		-- width = width,
		height = height,
		style = "minimal",
	})

	vim.api.nvim_set_option_value("winhighlight", "Normal:DebugFloat,FloatBorder:DebugFloat", {
		win = build_notifier,
	})

	-- Create terminal
	local chan = vim.api.nvim_open_term(buf, {})

	local stdout = vim.uv.new_pipe()
	local stderr = vim.uv.new_pipe()

	---@diagnostic disable-next-line: missing-fields
	local handle = vim.uv.spawn(cmd, {
		args = args,
		cwd = Util.root(),
		stdio = { nil, stdout, stderr },
        detached = true,
	}, function(code)
		-- vim.schedule(function()
		-- 	if code == 0 then
		-- 		close_terminal_window()
		-- 		Snacks.notify.success("Build successful")
		-- 	end
		-- end)
	end)

	pid = handle:get_pid()

	if stdout and stderr then
		stdout:read_start(function(err, data)
			assert(not err, err)
			if data then
				vim.schedule(function()
					vim.api.nvim_chan_send(chan, data)
				end)
			end
		end)

		stderr:read_start(function(err, data)
			assert(not err, err)
			if data then
				vim.schedule(function()
					vim.api.nvim_chan_send(chan, data)
				end)
			end
		end)
	else
		handle:kill(15)
	end

	-- Add keymapping to close the window
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", ":close<CR>", { noremap = true, silent = true })
end

-- this is to set args to be passed to zig run instead of asking each time
vim.keymap.set("n", "<leader>zba", function()
	local args = vim.fn.input("Run args: ")
	-- save args in a global variable
	vim.g.zig_run_args = args
end, {
	desc = "zig: Set build run args",
})

-- this is an easy zig build run from nvim
vim.keymap.set("n", "<leader>zbr", function()
	local args_str = vim.g.zig_run_args and (" --color on -- " .. vim.g.zig_run_args) or " --color on"
	local args = require("dap.utils").splitstr("build run " .. args_str)

	close_terminal_window()
	run_in_terminal_window("zig", args)
end, {
	desc = "zig: Build run (with args)",
})

vim.keymap.set("n", "<leader>zbw", function()
	zig_watcher.toggle()
end, {
	desc = "zig: Start build watcher",
})
