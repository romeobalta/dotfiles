return {
  -- {
  --
  --   "echasnovski/mini.pairs",
  --   enabled = false,
  -- },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_z = {}
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
      }

      opts.lsp = vim.tbl_extend("keep", opts.lsp, {
        documentation = {
          opts = {
            -- size = {
            --   width = 0.99,
            -- },
            -- anchor = "NW",
            -- relative = "editor",
            -- position = {
            --   row = 0,
            --   col = 0,
            -- },
            -- border = {
            --   padding = {
            --     top = 1,
            --     bottom = 1,
            --     left = 2,
            --     right = 2,
            --   },
            -- },
            win_options = {
              winblend = 0,
              winhighlight = "Normal:Pmenu,FloatBorder:SpecialBorder",
            },
          },
        },
      })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    keys = {
      {
        "<C-g>",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
    },
    opts = function(_, opts)
      opts.zen = {
        toggles = {
          dim = false,
        },
      }
      opts.notifier = {
        top_down = false,
      }
    end,
  },
}
