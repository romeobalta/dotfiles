return {
  "numToStr/Comment.nvim",
  keys = {
    { "gcc", mode = "n", desc = "Comment toggle current line" },
    { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
    { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
    { "gbc", mode = "n", desc = "Comment toggle current block" },
    { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
    { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    {
      "<leader>/",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      { desc = "Toggle comment" },
    },

    {
      "<leader>/",
      function()
        require("Comment.api").toggle.linewise(vim.fn.visualmode())()
      end,
      { mode = "v", desc = "Toggle comment (visual)" },
    },
  },
}
