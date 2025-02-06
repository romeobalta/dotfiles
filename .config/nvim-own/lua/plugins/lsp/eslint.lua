local auto_format = true

return {
  {
    "neovim/nvim-lspconfig",
    -- other settings removed for brevity
    opts = {
      ---@type lspconfig.options
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
            format = auto_format,
          },
        },
      },
      setup = {
        eslint = function()
          if not auto_format then
            return
          end

          local function get_client(buf)
            return Util.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = Util.lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })

          -- register the formatter with LazyVim
          Util.format.register(formatter)
        end,
      },
    },
  },
}
