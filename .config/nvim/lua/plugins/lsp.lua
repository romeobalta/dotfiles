local newKeys = {
  -- disable
  { "<c-k>", false, mode = "i" },
}

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      for _, newKey in ipairs(newKeys) do
        keys[#keys + 1] = newKey
      end
    end,
    keys = {},
    opts = {
      -- inlay_hints = { enabled = false },
      servers = {
        zls = {
          settings = {
            zls = {
              enable_build_on_save = true,
              build_on_save_step = "check",
              enable_inlay_hints = false,
            },
          },
        },
      },
      setup = {
        -- Disable inlay hints for vtsls
        vtsls = function(_, opts)
          LazyVim.lsp.on_attach(function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end
          end, "vtsls")
        end,
      },
    },
  },
}
