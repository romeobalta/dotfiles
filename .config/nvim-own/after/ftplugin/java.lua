vim.keymap.set("n", "<leader>dm", function()
  -- ask for recipe
  local recipe = vim.fn.input("Recipe: ")
  -- run make recipe
  vim.cmd("make " .. recipe)
end)
