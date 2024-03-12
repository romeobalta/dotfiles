return {
  "lewis6991/gitsigns.nvim",

  keys = {
    {
      "]g",
      function()
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
      end,
      desc = "Goto next hunk",
    },

    {
      "[g",
      function()
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
      end,
      desc = "Goto prev git hunk",
    },

    -- Actions on hunks
    {
      "<leader>gr",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Reset git hunk",
    },

    {
      "<leader>gp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview git hunk",
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
