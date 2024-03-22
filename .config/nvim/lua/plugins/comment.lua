return {
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
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>st", mode = { "n" }, false },
      { "<leader>sT", mode = { "n" }, false },

      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
}
