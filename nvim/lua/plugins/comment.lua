return {
  "numToStr/Comment.nvim",
  lazy = false,
  keys = {
    {
      "<leader>/",
    },

    {
      "<leader>/",
      mode = "v",
    },
  },
  config = function(_, opts)
    vim.keymap.set("n", "<leader>/", function()
      require("Comment.api").toggle.linewise.current()
    end, {
      desc = "Toggle comment",
    })

    vim.keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", {
      desc = "Toggle comment",
    })
    require("Comment").setup(opts)
  end,
}
