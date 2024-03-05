return {
  "lewis6991/gitsigns.nvim",

  keys = {
    {
      "g]",
      function()
        if vim.wo.diff then
          return "c]"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      desc = "Jump to next hunk",
    },

    {
      "g[",
      function()
        if vim.wo.diff then
          return "c["
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      desc = "Jump to prev hunk",
    },

    -- Actions on hunks
    {
      "<leader>gr",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Reset hunk",
    },

    {
      "<leader>gp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview hunk",
    },

    {
      "<leader>gb",
      function()
        package.loaded.gitsigns.blame_line()
      end,
      desc = "Blame line",
    },
  },
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "│" },
    },
  },
}
