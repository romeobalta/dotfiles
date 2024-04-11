return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    {
      "<C-n>",
      "<cmd> NvimTreeToggle <CR>",
      desc = "Toggle nvimtree",
    },
    {
      "<leader>e",
      "<cmd> NvimTreeFocus <CR>",
      desc = "Focus nvimtree",
    },
  },
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  lazy = false,
  opts = {
    filters = {
      dotfiles = false,
      exclude = { vim.fn.stdpath("config") .. "/lua/custom" },
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    view = {
      adaptive_size = false,
      side = "left",
      width = 100,
      preserve_window_proportions = true,
    },
    git = {
      enable = true,
      ignore = true,
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      open_file = {
        resize_window = true,
        quit_on_open = true,
      },
    },
    renderer = {
      root_folder_label = false,
      highlight_git = true,
      highlight_opened_files = "none",

      indent_markers = {
        enable = false,
      },

      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },

        glyphs = {
          default = "󰈚",
          symlink = "",
          folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = "",
            symlink = "",
            symlink_open = "",
            arrow_open = "",
            arrow_closed = "",
          },
          git = {
            unstaged = "",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "?",
            deleted = "✗",
            ignored = "◌",
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}
