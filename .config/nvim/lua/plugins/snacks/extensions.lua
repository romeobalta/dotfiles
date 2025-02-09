local M = {}

---@class snacks.notify
---@overload fun(msg: string|string[], opts?: snacks.notify.Opts)
local N = setmetatable({}, {
	__call = function(t, ...)
		return t.notify(...)
	end,
	__index = function(t, k)
		local Snacks_notify = require("snacks.notify")

		if Snacks_notify[k] then
			return Snacks_notify[k]
		end

		return t[k]
	end,
})

-- stylua: ignore
local success_hl = {
	title   = "SnacksNotifierTitleSuccess",
	icon    = "SnacksNotifierIconSuccess",
	border  = "SnacksNotifierBorderSuccess",
	footer  = "SnacksNotifierSuccess",
	msg     = "SnacksNotifierSuccess",
}

---@param msg string|string[]
---@param opts? snacks.notify.Opts
function N.success(msg, opts)
	return N.notify(
		msg,
		vim.tbl_extend("force", opts or {}, {
			hl = success_hl,
			icon = "",
		})
	)
end

---@type snacks.notifier.render
function M.minimal_improved(buf, notif, ctx)
	ctx.opts.border = "none"
	local whl = ctx.opts.wo.winhighlight

	-- snacks.notifier replaces unknown levels with "info"
	-- so we can use the icon hl to override the message hl
	local hl_msg = ctx.hl.icon == success_hl.icon and success_hl.msg or ctx.hl.msg
	ctx.opts.wo.winhighlight = whl:gsub(ctx.hl.msg, hl_msg .. "Minimal")

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, "\n"))
	vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
		virt_text = { { " " .. notif.icon, ctx.hl.icon } },
		virt_text_pos = "right_align",
	})
end

function M.set_lazygit_binds()
	if vim.fn.executable("lazygit") == 1 then
		vim.keymap.set("n", "<C-g>", function()
			Snacks.lazygit({ cwd = Util.root.git() })
		end, { desc = "Lazygit (Root Dir)" })
		vim.keymap.set("n", "<leader>gf", function()
			Snacks.picker.git_log_file()
		end, { desc = "Git Current File History" })
		vim.keymap.set("n", "<leader>gl", function()
			Snacks.picker.git_log({ cwd = Util.root.git() })
		end, { desc = "Git Log" })
		vim.keymap.set("n", "<leader>gL", function()
			Snacks.picker.git_log()
		end, { desc = "Git Log (cwd)" })
	end
end

function M.setup()
	-- Setup some globals for debugging (lazy-loaded)
	_G.dd = function(...)
		Snacks.debug.inspect(...)
	end
	_G.bt = function()
		Snacks.debug.backtrace()
	end
	vim.print = _G.dd -- Override print to use snacks for `:=` command

	-- override the snacks notifier with the one that has a success notification
	Snacks.notify = N

	M.set_lazygit_binds()
end

return M
