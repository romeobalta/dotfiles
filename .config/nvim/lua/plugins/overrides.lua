return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })

      opts.views = {
        vsplit = {
          size = "20%",
        },
      }

      opts.presets.lsp_doc_border = {
        views = {
          hover = {
            border = {
              style = "single",
            },
          },
        },
      }
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
  },
}
