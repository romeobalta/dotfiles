vim.keymap.set("n", "<leader>dm", function()
  -- ask for recipe
  local recipe = vim.fn.input({
    prompt = "Recipe: ",
    default = "re",
    cancelreturn = "-1",
  })
  -- run make recipe
  if recipe == "-1" then
    return
  end

  vim.cmd("make " .. recipe)
end)
