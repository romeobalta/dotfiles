local function open_terminal_window(stdout, stderr)
  -- Create a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.min(120, math.floor(vim.o.columns * 0.8))
  local height = math.min(20, math.floor(vim.o.lines * 0.8))

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width)),
    row = math.floor((vim.o.lines - height)),
    style = "minimal",
    border = "rounded",
  })

  vim.api.nvim_set_option_value("winhighlight", "Normal:DebugFloat,FloatBorder:DebugFloat", {
    win = win,
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
  Snacks.notify.info("Building...", {
    id = "build_notifier",
    title = "Zig",
    style = "minimal",
    timeout = false,
  })
  vim.system({ "zig", "build", "--color", "on" }, {
    cwd = LazyVim.root(),
  }, function(res)
    vim.schedule(function()
      -- Send status message
      if res.code == 0 then
        Snacks.notify.info("Build succeeded", { id = "build_notifier", title = "Zig", icon = "", style = "minimal" })
      else
        Snacks.notifier.hide("build_notifier")
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
  -- Run zig build run command
  Snacks.notify.info("Build started", { id = "build_notifier", title = "Zig", icon = "", style = "minimal" })
  vim.system(command, {
    cwd = LazyVim.root(),
  }, function(res)
    vim.schedule(function()
      Snacks.notifier.hide("build_notifier")
      open_terminal_window(res.stdout, res.stderr)
    end)
  end)
end, {
  desc = "zig: build run",
})
