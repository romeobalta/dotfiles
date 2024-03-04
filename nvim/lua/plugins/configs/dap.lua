local dap = require("dap")
local codelldb = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension"

dap.adapters.lldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb .. "/adapter/codelldb",
		args = { "--port", "${port}" },
	},
}

dap.configurations.rust = {
	{
		name = "Debug",
		type = "lldb",
		request = "launch",
		program = function()
			local cwd = vim.fn.getcwd()
			local package_name = cwd:match("([^/]+)$")

			return cwd .. "/target/debug/" .. package_name
		end,
	},
}

local js_based_languages = { "typescript", "javascript", "javascriptreact", "typescriptreact" }

for _, language in ipairs(js_based_languages) do
	dap.configurations[language] = {
		-- attach to a node process that has been started with
		-- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
		-- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
		{
			-- use nvim-dap-vscode-js's pwa-node debug adapter
			type = "pwa-node",
			-- attach to an already running node process with --inspect flag
			-- default port: 9222
			request = "attach",
			-- allows us to pick the process using a picker
			processId = require("dap.utils").pick_process,
			-- name of the debug action you have to select for this config
			name = "Attach debugger to existing `node --inspect` process",
			-- for compiled languages like TypeScript or Svelte.js
			sourceMaps = true,
			-- resolve source maps in nested locations while ignoring node_modules
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			-- path to src in vite based projects (and most other projects as well)
			cwd = "${workspaceFolder}/src",
			-- we don't want to debug code inside node_modules, so skip it!
			skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },

			localRoot = "${workspaceFolder}",
			remoteRoot = "/src",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Auto Attach",
			cwd = vim.fn.getcwd(),
			localRoot = "${workspaceFolder}",
			remoteRoot = "/src",
			sourceMaps = true,
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
		},
		{
			type = "pwa-chrome",
			name = "Launch Chrome to debug client",
			request = "launch",
			url = "http://localhost:5173",
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}/src",
			-- skip files from vite's hmr
			skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
		},
		-- only if language is javascript, offer this debug action
		language == "javascript"
				and {
					-- use nvim-dap-vscode-js's pwa-node debug adapter
					type = "pwa-node",
					-- launch a new process to attach the debugger to
					request = "launch",
					-- name of the debug action you have to select for this config
					name = "Launch file in new node process",
					-- launch current file
					program = "${file}",
					cwd = "${workspaceFolder}",
				}
			or nil,
	}
end

require("dap.ext.vscode").load_launchjs(
	nil,
	{
		["pwa-node"] = js_based_languages,
		["node"] = js_based_languages,
		["chrome"] = js_based_languages,
		["pwa-chrome"] = js_based_languages,
	}
)

print("Loaded dap.lua")
