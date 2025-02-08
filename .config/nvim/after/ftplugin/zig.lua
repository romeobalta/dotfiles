local function close_terminal_window()
	-- check if vim.g.build_notifier is set
	-- if is set, close the buffer inside it and close the window
	if vim.g.build_notifier then
		vim.api.nvim_win_close(vim.g.build_notifier, true)
		vim.g.build_notifier = nil
	end
end

local function open_terminal_window(stdout, stderr)
	local buf = vim.api.nvim_create_buf(false, true)
	local height = math.min(10, math.floor(vim.o.lines * 0.8))

	-- If we close the window, we need to set the global variable to nil
	vim.api.nvim_create_autocmd({ "BufHidden" }, {
		buffer = buf,
		callback = function()
			vim.g.build_notifier = nil
		end,
	})

	-- Close the terminal window if it's already open
	close_terminal_window()

	vim.g.build_notifier = vim.api.nvim_open_win(buf, true, {
		split = "below",
		-- width = width,
		height = height,
		style = "minimal",
	})

	vim.api.nvim_set_option_value("winhighlight", "Normal:DebugFloat,FloatBorder:DebugFloat", {
		win = vim.g.build_notifier,
	})

	-- Create terminal
	local chan = vim.api.nvim_open_term(buf, {})

	-- Send command output
	if stdout and stdout ~= "" then
		vim.api.nvim_chan_send(chan, stdout)
	end

	if stderr and stderr ~= "" then
		vim.api.nvim_chan_send(chan, stderr)
	end

	-- Add keymapping to close the window
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", ":close<CR>", { noremap = true, silent = true })
end

local function show_loading_notification(message)
	local spinner = { "⠄", "⠆", "⠇", "⠋", "⠙", "⠸", "⠰", "⠠", "⠰", "⠸", "⠙", "⠋", "⠇", "⠆" }
	local interval = 80
	local timer = vim.uv.new_timer()

	if not timer then
		return nil
	end

	local start_time = vim.uv.hrtime()

	timer:start(interval, interval, vim.schedule_wrap(function()
		local index = (math.floor((vim.uv.hrtime() - start_time) / (1e6 * interval)) % #spinner) + 1
		Snacks.notify.info(spinner[index] .. " " .. (message or "Building") .. " ...", {
			id = "build_notifier",
			title = "Zig",
		})
	end))

	return timer
end

-- this is to set args to be passed to zig run instead of asking each time
vim.keymap.set("n", "<leader>da", function()
	local args = vim.fn.input("Run args: ")
	-- save args in a global variable
	vim.g.zig_run_args = args
end, {
	desc = "zig: set run args",
})

-- this is an easy zig build from nvim
vim.keymap.set("n", "<leader>dm", function()
	close_terminal_window()

	local timer = show_loading_notification()

	vim.system({ "zig", "build", "--color", "on" }, {
		cwd = Util.root(),
	}, function(res)
		vim.schedule(function()
			if timer ~= nil then
				timer:stop()
				timer:close()
			end

			-- Send status message
			if res.code == 0 then
				Snacks.notifier.hide("build_notifier")
				Snacks.notify.success("Build succeeded", { id = "build_notifier", title = "Zig", icon = "" })
			else
				Snacks.notifier.hide("build_notifier")
				Snacks.notify.error("Build failed", { id = "build_notifier", title = "Zig", icon = "" })
				open_terminal_window(res.stdout, res.stderr)
			end
		end)
	end)
end, {
	desc = "zig: build",
})

-- this is an easy zig build run from nvim
vim.keymap.set("n", "<leader>dr", function()
	local args = vim.g.zig_run_args and (" --color on -- " .. vim.g.zig_run_args) or " --color on"
	local command = require("dap.utils").splitstr("zig build run" .. args)

	close_terminal_window()

	local timer = show_loading_notification("Running")

	vim.system(command, {
		cwd = Util.root(),
	}, function(res)
		if timer ~= nil then
			timer:stop()
			timer:close()
		end

		vim.schedule(function()
			Snacks.notifier.hide("build_notifier")
			open_terminal_window(res.stdout, res.stderr)
		end)
	end)
end, {
	desc = "zig: build run",
})
