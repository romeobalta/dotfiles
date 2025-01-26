local tokyodark = require("config.colorscheme")

return {
  -- theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = false,
      on_colors = tokyodark.on_colors,
      on_highlights = tokyodark.on_highlights,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_b = {} -- Branc moved to y
      opts.sections.lualine_y = { "branch" }

      local diagnostics = vim.deepcopy(opts.sections.lualine_c[2])
      diagnostics.color = "DiagnosticsLualine"

      table.insert(opts.sections.lualine_c, diagnostics)

      opts.sections.lualine_z = { "selectioncount", "searchcount" } -- These are most useful here

      table.remove(opts.sections.lualine_c, 2) -- Remove the diagnostics component, which is at index 2
      table.remove(opts.sections.lualine_x, 3) -- Remove mode stuff
    end,
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
      opts.notifier = {
        top_down = false,
      }

      opts.statuscolumn = {
        left = { "fold", "sign" },
        right = { "git", "mark" },
        folds = {
          open = true,
        },
      }
    end,
  },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- opts.completion.trigger = { show_in_snippet = false }
      opts.completion.ghost_text = {
        enabled = false,
      }

      opts.signature = {
        enabled = true,
      }

      opts.keymap.preset = "super-tab"
    end,
  },
  {
    "echasnovski/mini.comment",
    lazy = false,
    opts = function(_, opts)
      opts.mappings = {
        comment_line = "<leader>/",
        comment_visual = "<leader>/",
      }
    end,
  },
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>/", false },
      { "<leader>fb", false },

      { "<leader><space>", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>fs", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>fS", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>fl", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    },

    opts = function(_, opts)
      opts.fzf_opts = {
        ["--layout"] = "default",
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      local newKeys = {
        -- disable
        { "<c-k>", false, mode = "i" },
      }

      for _, newKey in ipairs(newKeys) do
        keys[#keys + 1] = newKey
      end
    end,
    keys = {},
    opts = {
      -- inlay_hints = { enabled = false },
      servers = {
        zls = {
          settings = {
            zls = {
              enable_build_on_save = true,
              build_on_save_step = "check",
              enable_inlay_hints = false,
            },
          },
        },
      },
      setup = {
        -- Disable inlay hints for vtsls
        vtsls = function(_, opts)
          LazyVim.lsp.on_attach(function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end
          end, "vtsls")
        end,
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      local dap = require("dap")
      if not dap.adapters["codelldb"] then
        require("dap").adapters["codelldb"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "codelldb",
            args = {
              "--port",
              "${port}",
            },
          },
        }
      end
      for _, lang in ipairs({ "zig" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },

  -- disabled
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
}
