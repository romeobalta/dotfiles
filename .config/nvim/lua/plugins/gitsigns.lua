return {
  "lewis6991/gitsigns.nvim",
  keys = {
    {
      "]g",
      function()
        vim.schedule(function()
          require("gitsigns").nav_hunk("next")
        end)
      end,
      desc = "Goto next hunk",
    },
    {
      "[g",
      function()
        vim.schedule(function()
          require("gitsigns").nav_hunk("prev")
        end)
      end,
      desc = "Goto prev hunk",
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
