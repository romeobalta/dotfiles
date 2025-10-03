local LazyUtil = require("lazy.core.util")

---@class lazyvim.util: LazyUtilCore
---@field config lazyvim.util.config
---@field cmp lazyvim.util.cmp
---@field lsp lazyvim.util.lsp
---@field root lazyvim.util.root
---@field format lazyvim.util.format
local M = {}

setmetatable(M, {
	__index = function(t, k)
		if LazyUtil[k] then
			return LazyUtil[k]
		end
		---@diagnostic disable-next-line: no-unknown
		t[k] = require("util." .. k)
		return t[k]
	end,
})

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
	if vim.api.nvim_get_mode().mode == "i" then
		vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
	end
end

function M.is_win()
	return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param name string
function M.get_plugin(name)
	return require("lazy.core.config").spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
	local plugin = M.get_plugin(name)
	path = path and "/" .. path or ""
	return plugin and (plugin.dir .. path)
end

---@param plugin string
function M.has(plugin)
	return M.get_plugin(plugin) ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

function M.lazy_file()
	-- Add support for the LazyFile event
	local Event = require("lazy.core.handler.event")

	Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
	Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

---@param name string
function M.opts(name)
	local plugin = M.get_plugin(name)
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
	local ret = {}
	local seen = {}
	for _, v in ipairs(list) do
		if not seen[v] then
			table.insert(ret, v)
			seen[v] = true
		end
	end
	return ret
end

function M.is_loaded(name)
	local Config = require("lazy.core.config")
	return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
	if M.is_loaded(name) then
		fn(name)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end

---@param icon string
---@param status fun(): nil|"ok"|"error"|"pending"
function M.lualine_status(icon, status)
	local colors = {
		ok = "Special",
		error = "DiagnosticError",
		pending = "DiagnosticWarn",
	}
	return {
		function()
			return icon
		end,
		cond = function()
			return status() ~= nil
		end,
		color = function()
			return { fg = Snacks.util.color(colors[status()] or colors.ok) }
		end,
	}
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
	pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
	local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
	opts = opts or {}
	opts.warn = opts.warn == nil and true or opts.warn
	path = path or ""
	local ret = root .. "/packages/" .. pkg .. path
	if opts.warn and not vim.loop.fs_stat(ret) and not require("lazy.core.config").headless() then
		M.warn(
			("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(
				pkg,
				path
			)
		)
	end
	return ret
end

local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
	return function(...)
		local key = vim.inspect({ ... })
		cache[fn] = cache[fn] or {}
		if cache[fn][key] == nil then
			cache[fn][key] = fn(...)
		end
		return cache[fn][key]
	end
end

--- This extends a deeply nested list with a key in a table
--- that is a dot-separated string.
--- The nested list will be created if it does not exist.
---@generic T
---@param t T[]
---@param key string
---@param values T[]
---@return T[]?
function M.extend(t, key, values)
	local keys = vim.split(key, ".", { plain = true })
	for i = 1, #keys do
		local k = keys[i]
		t[k] = t[k] or {}
		if type(t) ~= "table" then
			return
		end
		t = t[k]
	end
	return vim.list_extend(t, values)
end


local _defaults = {} ---@type table<string, boolean>

-- Determines whether it's safe to set an option to a default value.
--
-- It will only set the option if:
-- * it is the same as the global value
-- * it's current value is a default value
-- * it was last set by a script in $VIMRUNTIME
---@param option string
---@param value string|number|boolean
---@return boolean was_set
function M.set_default(option, value)
	local l = vim.api.nvim_get_option_value(option, { scope = "local" })
	local g = Util.config._options[option] or vim.api.nvim_get_option_value(option, { scope = "global" })

	_defaults[("%s=%s"):format(option, value)] = true
	local key = ("%s=%s"):format(option, l)

	local source = ""
	if l ~= g and not _defaults[key] then
		-- Option does not match global and is not a default value
		-- Check if it was set by a script in $VIMRUNTIME
		local info = vim.api.nvim_get_option_info2(option, { scope = "local" })
		---@param e vim.fn.getscriptinfo.ret
		local scriptinfo = vim.tbl_filter(function(e)
			return e.sid == info.last_set_sid
		end, vim.fn.getscriptinfo())
		source = scriptinfo[1] and scriptinfo[1].name or ""
		local by_rtp = #scriptinfo == 1 and vim.startswith(scriptinfo[1].name, vim.fn.expand("$VIMRUNTIME"))
		if not by_rtp then
			if vim.g.lazyvim_debug_set_default then
				Util.warn(
					("Not setting option `%s` to `%q` because it was changed by a plugin."):format(option, value),
					{ title = "LazyVim", once = true }
				)
			end
			return false
		end
	end

	if vim.g.lazyvim_debug_set_default then
		Util.info({
			("Setting option `%s` to `%q`"):format(option, value),
			("Was: %q"):format(l),
			("Global: %q"):format(g),
			source ~= "" and ("Last set by: %s"):format(source) or "",
			"buf: " .. vim.api.nvim_buf_get_name(0),
		}, { title = "LazyVim", once = true })
	end

	vim.api.nvim_set_option_value(option, value, { scope = "local" })
	return true
end

return M
