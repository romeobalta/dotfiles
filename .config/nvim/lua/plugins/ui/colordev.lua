local M = {
	colorscheme = "tokyonight",
	globals = { vim = vim },
	cache = {},
	pattern = "lua/plugins/ui/tokyo.lua",
	opts = {},
    tokyo = {}
}

function M.reset()
	require("tokyonight.util").cache.clear()
	local colors = require("tokyonight.colors").setup({
		on_colors = M.tokyo.dull_colors,
		on_highlights = M.tokyo.mono_highlights,
	})
	M.globals = {
		colors = colors,
		c = colors,
	}
end

---@param name string
function M.hl_group(name)
	-- check if the name starts with hl. then remove it
	if name:find("^hl%.") then
		return name:sub(4)
	end

	-- check if name starts with hl[" then extract what is inside the quotes
	if name:find('^hl%["') then
		return name:match('^hl%["(.-)"')
	end

	return name
end

return {
	"echasnovski/mini.hipatterns",
	lazy = true,
	event = "BufEnter */" .. M.pattern,
	config = function(_, opts)
		require("mini.hipatterns").setup(opts)

		local function reload()
			M.cache = {}
			package.loaded["plugins.ui.tokyo"] = nil
			M.tokyo = require("plugins.ui.tokyo")
			require("tokyonight").setup({
				on_colors = M.tokyo.dull_colors,
				on_highlights = M.tokyo.mono_highlights,
			})
			M.reset()
			local colorscheme = vim.g.colors_name or M.colorscheme
			colorscheme = colorscheme:find(M.colorscheme) and colorscheme or M.colorscheme
			vim.cmd.colorscheme(colorscheme)
			local hi = require("mini.hipatterns")
			for _, buf in ipairs(require("mini.hipatterns").get_enabled_buffers()) do
				hi.update(buf)
			end
		end
		reload = vim.schedule_wrap(reload)

		reload()

		local augroup = vim.api.nvim_create_augroup("colorscheme_dev", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = augroup,
			pattern = "*/" .. M.pattern,
			callback = reload,
		})
	end,
	opts = function(_, opts)
		local hi = require("mini.hipatterns")

		opts.highlighters = vim.tbl_extend("keep", opts.highlighters or {}, {
			hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),

			hl_group = {
				pattern = function(buf)
					return vim.api.nvim_buf_get_name(buf):find(M.pattern) and '^%s*()hl%.?%[?"?[%w%.@]+"?%]?()%s*='
				end,
				group = function(buf, match)
					local group = M.hl_group(match)
					if group then
						if M.cache[group] == nil then
							M.cache[group] = false
							local hl = vim.api.nvim_get_hl(0, { name = group, link = false, create = false })
							if not vim.tbl_isempty(hl) then
								hl.fg = hl.fg or vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg
								M.cache[group] = true
								vim.api.nvim_set_hl(0, group .. "Dev", hl)
							end
						end
						return M.cache[group] and group .. "Dev" or nil
					end
				end,
				extmark_opts = { priority = 2000 },
			},

			hl_color = {
				pattern = {
					"%f[%w]()c%.[%w_%.]+()%f[%W]",
					"%f[%w]()colors%.[%w_%.]+()%f[%W]",
					"%f[%w]()vim%.g%.terminal_color_%d+()%f[%W]",
				},
				group = function(_, match)
					local parts = vim.split(match, ".", { plain = true })
					local color = vim.tbl_get(M.globals, unpack(parts))
					return type(color) == "string" and require("mini.hipatterns").compute_hex_color_group(color, "fg")
				end,
				extmark_opts = function(_, _, data)
					return {
						virt_text = { { "██", data.hl_group } },
						virt_text_pos = "inline",
						priority = 2000,
					}
				end,
			},
		})
	end,
}
