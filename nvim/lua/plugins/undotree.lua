return {
  "mbbill/undotree",
  keys = {
    {
      "<leader>u",
      "<cmd> UndotreeToggle <CR>",
      desc = " undotree",
    },
  },
  cmd = "UndotreeToggle",
  config = function()
    vim.g.undotree_SplitWidth = 50
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}
