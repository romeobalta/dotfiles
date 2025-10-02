local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string|string[], cond?:fun():boolean}
---@alias LazyKeysLsp LazyKeys|{has?:string|string[], cond?:fun():boolean}

function M.diagnostic_goto(next, severity)
	local count = next and 1 or -1
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		vim.diagnostic.jump({ count = count, severity = severity, float = true })
	end
end

---@param id number
---@param name string
function M.restart_lsp(id, name)
	local configs = require("lspconfig.configs")
	local client = vim.lsp.get_client_by_id(id)

	if client and configs[name] then
		local buffers = vim.lsp.get_buffers_by_client_id(id)
		client.stop()

		local timer = assert(vim.uv.new_timer())

		timer:start(
			500,
			100,
			vim.schedule_wrap(function()
				if client and client.is_stopped() then
					for _, buf in pairs(buffers) do
						require("lspconfig.configs")[name].launch(buf)
					end
					client = nil
				end

				if client == nil and not timer:is_closing() then
					timer:close()
				end
			end)
		)
	end
end

function M.pick_lsp()
	local fzf_lua = require("fzf-lua")
	local icons = require("config").icons.lsp
	local t = {}

	local clients = {}

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		local icon = icons[client.name] or " "
		local client_name_aligned = client.name .. string.rep(" ", 12 - #tostring(client.name))
		clients[client.id] = client.name
		table.insert(t, icon .. client_name_aligned .. " - ID: " .. client.id)
	end

	fzf_lua.fzf_exec(t, {
		prompt = "LSP> ",
		winopts = { height = 0.3, width = 0.3 },
		fn_transform = function(x)
			return fzf_lua.utils.ansi_codes.magenta(x)
		end,
		actions = {
			["default"] = function(selected)
				for _, client in ipairs(selected) do
					local id = tonumber(client:match("ID: (%d+)")) or -1
					M.restart_lsp(id, clients[id])
				end
			end,
			["ctrl-r"] = function(selected)
				for _, client in ipairs(selected) do
					local id = tonumber(client:match("ID: (%d+)")) or -1
					M.restart_lsp(id, clients[id])
				end
			end,
		},
	})
end

---@return LazyKeysLspSpec[]
function M.get()
	if M._keys then
		return M._keys
	end
	M._keys = {
		{ "<leader>ci", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
		{
			"gd",
			vim.lsp.buf.definition,
			desc = "Goto Definition",
			has = "definition",
		},
		{
			"gr",
			vim.lsp.buf.references,
			desc = "References",
			nowait = true,
		},
		{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
		{ "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
		{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
		{
			"K",
			function()
				return vim.lsp.buf.hover()
			end,
			desc = "Hover",
		},
		{
			"gK",
			function()
				return vim.lsp.buf.signature_help()
			end,
			desc = "Signature Help",
			has = "signatureHelp",
		},
		{
			"<c-k>",
			function()
				return vim.lsp.buf.signature_help()
			end,
			mode = "i",
			desc = "Signature Help",
			has = "signatureHelp",
		},
		{
			"<leader>ca",
			vim.lsp.buf.code_action,
			desc = "Code Action",
			mode = { "n", "v" },
			has = "codeAction",
		},
		{
			"<leader>cc",
			vim.lsp.codelens.run,
			desc = "Run Codelens",
			mode = { "n", "v" },
			has = "codeLens",
		},
		{
			"<leader>cC",
			vim.lsp.codelens.refresh,
			desc = "Refresh & Display Codelens",
			mode = { "n" },
			has = "codeLens",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
			mode = { "n" },
			has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
		},
		{
			"<leader>cr",
			vim.lsp.buf.rename,
			expr = true,
			desc = "Rename (inc-rename.nvim)",
			has = "rename",
		},
		{
			"<leader>cA",
			Util.lsp.action.source,
			desc = "Source Action",
			has = "codeAction",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			has = "documentHighlight",
			desc = "Next Reference",
			cond = function()
				return Snacks.words.is_enabled()
			end,
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			has = "documentHighlight",
			desc = "Prev Reference",
			cond = function()
				return Snacks.words.is_enabled()
			end,
		},
		{ "<leader>cx", M.pick_lsp, desc = "LSP Actions" },
		{ "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
		{ "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
		{ "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
		{ "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
		{ "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
		{ "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
		{ "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
		{
			"<leader>fm",
			function()
				Util.format({ force = true })
			end,
			desc = "Format",
			mode = { "n", "v" },
		},
	}

	return M._keys
end

---@param method string|string[]
function M.has(buffer, method)
	if type(method) == "table" then
		for _, m in ipairs(method) do
			if M.has(buffer, m) then
				return true
			end
		end
		return false
	end
	method = method:find("/") and method or "textDocument/" .. method
	local clients = vim.lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client:supports_method(method) then
			return true
		end
	end
	return false
end

---@return LazyKeysLsp[]
function M.resolve(buffer)
	local Keys = require("lazy.core.handler.keys")
	if not Keys.resolve then
		return {}
	end
	local spec = vim.tbl_extend("force", {}, M.get())
	local opts = Util.opts("nvim-lspconfig")
	local clients = vim.lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
		vim.list_extend(spec, maps)
	end
	return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
	local Keys = require("lazy.core.handler.keys")
	local keymaps = M.resolve(buffer)

	for _, keys in pairs(keymaps) do
		local has = not keys.has or M.has(buffer, keys.has)
		local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

		if has and cond then
			local opts = Keys.opts(keys)
			opts.cond = nil
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
		end
	end
end

return M
