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
      opts.notify = {
        view = "mini",
      }

      opts.messages = {
        view = "mini",
        view_error = "mini",
        view_warn = "mini",
      }

      opts.routes = {
        {
          view = "mini",
          filter = { event = "msg_showmode" },
        },
      }

      opts.lsp = vim.tbl_extend("keep", opts.lsp, {
        documentation = {
          opts = {
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
        left = { "sign", "fold" },
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
      opts.completion.trigger = { show_in_snippet = false }
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

      { "<leader><space>", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
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
      inlay_hints = { enabled = false },
      servers = {
        zls = {
          cmd = { vim.fn.expand("$HOME") .. "/soft/zls/zig-out/bin/zls" },

          settings = {
            zls = {
              enable_build_on_save = true,
              build_on_save_step = "check",
              -- enable_inlay_hints = false,
            },
          },
        },
      },
      setup = {
        -- Disable inlay hints for vtsls
        -- vtsls = function(_, opts)
        -- LazyVim.lsp.on_attach(function(client, bufnr)
        -- if client.server_capabilities.inlayHintProvider then
        --   vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        -- end
        -- client.server_capabilities.semanticTokensProvider = nil
        -- end, "vtsls")
        -- end,
      },
    },
  },

  -- dap overrides
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dr", false },
      { "<leader>da", false },
    },
    opts = function(_, opts)
      local dap = require("dap")

      -- this provider is so we can put launch.json files in .dap.json
      dap.providers.configs["_.root.launch.json"] = function()
        local root = LazyVim.root()
        local path = root .. "/.dap.json"
        local ok, configs = pcall(require("dap.ext.vscode").getconfigs, path)
        return ok and configs or {}
      end

      -- this is a hook that allows as to use string args in .dap.json
      -- it's useful if you want to read a single input and accept multiple args
      -- as the config expects a list of args instead of a single string
      dap.listeners.on_config["_.launch.json"] = function(config)
        local _config = vim.deepcopy(config)
        -- if _config has property args and it's a string, split it
        if _config.args and type(_config.args) == "string" then
          _config.args = require("dap.utils").splitstr(_config.args)
        end
        return _config
      end

      -- zig defaults
      for _, lang in ipairs({ "zig" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "LLDB: Launch with args",
            program = function()
              return require("dap.utils").pick_file({
                executables = true,
                path = LazyVim.root(),
                filter = function(filepath)
                  -- look only for paths in the cwd with zig-out in them
                  return vim.fn.match(filepath, "zig-out") ~= -1 and vim.fn.match(filepath, LazyVim.root()) ~= -1
                end,
              })
            end,
            args = function()
              local args = vim.fn.input("Arguments: ", "", "file") -- Read some args
              return args == "" and {} or require("dap.utils").splitstr(args)
            end,
            cwd = vim.fn.getcwd(),
          },
          {
            type = "codelldb",
            request = "attach",
            name = "LLDB: Attach to process",
            pid = function()
              return require("dap.utils").pick_process({
                filter = function(proc)
                  return vim.fn.match(proc.name, "zig-out") ~= -1
                end,
              })
            end,
            cwd = vim.fn.getcwd(),
          },
        }
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    opts = function(_, opts)
      local dap = require("dap")
      -- remove dapui_config from event_terminated
      dap.listeners.before.event_terminated["dapui_config"] = function() end
      dap.listeners.before.event_exited["dapui_config"] = function() end
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
