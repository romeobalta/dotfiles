local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.prettier,
  b.code_actions.eslint_d,
  b.diagnostics.eslint_d,

  -- Lua
  b.formatting.stylua,

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

  -- cpp
  b.formatting.clang_format,
}

null_ls.setup {
  debug = true,
  sources = sources,
}

vim.api.nvim_create_user_command("NullLsToggle", function()
    -- you can also create commands to disable or enable sources
    require("null-ls").toggle({})
end, {})