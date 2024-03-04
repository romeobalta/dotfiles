return {
  "lukas-reineke/indent-blankline.nvim",
  version = "2.20.7",

  keys = {
    {
      "<leader>cc",
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd([[normal! _]])
        end
      end,

      desc = "Jump to current context",
    },
  },

  opts = {
    indentLine_enabled = 1,
    filetype_exclude = {
      "",
      "TelescopePrompt",
      "TelescopeResults",
      "alpha",
      "help",
      "lazy",
      "lsp-installer",
      "lspinfo",
      "mason",
      "norg",
      "nvchad_cheatsheet",
      "nvcheatsheet",
      "nvdash",
      "packer",
      "terminal",
    },
    buftype_exclude = { "terminal" },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    show_current_context = true,
    show_current_context_start = true,
  },

  config = function(_, opts)
    require("indent_blankline").setup(opts)
  end,
}
