local keys = {
  {
    "<leader>fs",
    function()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end,
    desc = " live grep",
  },
  {
    "<leader>ff",
    "<cmd> Telescope find_files <CR>",
    desc = "Find files",
  },
  {
    "<leader>fa",
    "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
    desc = "Find all",
  },
  {
    "<leader>fl",
    "<cmd> Telescope buffers <CR>",
    desc = "Find buffers",
  },
  {
    "<leader>fh",
    "<cmd> Telescope help_tags <CR>",
    desc = "Help page",
  },
  {
    "<leader>fo",
    "<cmd> Telescope oldfiles <CR>",
    desc = "Find oldfiles",
  },
  {
    "<leader>fz",
    "<cmd> Telescope current_buffer_fuzzy_find <CR>",
    desc = "Find in current buffer",
  },
  {
    "<leader>fk",
    "<cmd> Telescope keymaps <CR>",
    desc = " show keys",
  },
  {
    "<leader>fds",
    "<cmd> Telescope lsp_document_symbols <CR>",
    desc = "@ show document symbols",
  },
  {
    "<leader>fch",
    "<cmd> Telescope command_history <CR>",
    desc = " show command history",
  },
  {
    "<leader>fsh",
    "<cmd> Telescope search_history <CR>",
    desc = " show search history",
  },
  {
    "<leader>fgc",
    "<cmd> Telescope git_commits <CR>",
    desc = "Git commits",
  },
  {
    "<leader>fgs",
    "<cmd> Telescope git_status <CR>",
    desc = "Git status",
  },
  {
    "<leader>pt",
    "<cmd> Telescope terms <CR>",
    desc = "Pick hidden term",
  },
  { "<leader>q", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
  { "<leader>Q", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },

  -- disable
  {
    "<leader>fb",
    false,
  },
  {
    "<leader>/",
    false,
  },
  { "<leader>sd", false },
  { "<leader>sD", false },
}

local options = function()
  local sorters = require("telescope.sorters")
  local previewers = require("telescope.previewers")
  local actions = require("telescope.actions")
  local themes = require("telescope.themes")

  return {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "-L",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      file_sorter = sorters.get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = sorters.get_generic_fuzzy_sorter,
      path_display = { "truncate" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = previewers.vim_buffer_cat.new,
      grep_previewer = previewers.vim_buffer_vimgrep.new,
      qflist_previewer = previewers.vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = previewers.buffer_previewer_maker,
      mappings = {
        n = { ["q"] = actions.close },
      },

      pickers = {
        diagnostics = {
          theme = "ivy",
          sort_by = "severity",
        },

        buffers = {
          mappings = {
            i = {
              ["<c-d>"] = "delete_buffer",
            },
            n = {
              ["<c-d>"] = "delete_buffer",
            },
          },
        },
      },
    },

    extensions_list = { "fzf", "ui-select", "live_grep_args", "harpoon" },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      ["ui-select"] = {
        themes.get_cursor({}),
      },
      live_grep_args = {},
    },
  }
end

return {
  "nvim-telescope/telescope.nvim",
  keys = keys,
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "danielvolchek/tailiscope.nvim",
  },
  opts = options,
}
