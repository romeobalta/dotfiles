return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.window = {
        completion = require("cmp").config.window.bordered({
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
        documentation = require("cmp").config.window.bordered({
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
      }

      local cmp = require("cmp")

      opts.mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<Esc>"] = function()
          if cmp.visible() then
            cmp.close()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
          end
        end,
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        -- disable for copilot panel
        ["<C-p>"] = cmp.mapping(function(fallback)
          cmp.close()
          fallback()
        end, { "i" }),
      })

      opts.experimental = {
        ghost_text = false,
      }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    keys = {
      {
        "<tab>",
        false,
        mode = "i",
      },
    },
  },
}
