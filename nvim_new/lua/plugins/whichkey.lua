return {
  "folke/which-key.nvim",
  keys = {

    {
      "<leader>wK",
      function()
        vim.cmd("WhichKey")
      end,
      desc = "Which-key all keymaps",
    },
    {
      "<leader>wk",
      function()
        local input = vim.fn.input("WhichKey: ")
        vim.cmd("WhichKey " .. input)
      end,
      desc = "Which-key query lookup",
    },
  },
  cmd = "WhichKey",
  config = function(_, opts)
    require("which-key").setup(opts)
  end,
}
