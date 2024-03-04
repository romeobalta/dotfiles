return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
  },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "comment",
      "css",
      "dockerfile",
      "dot",
      "html",
      "http",
      "javascript",
      "json",
      "json5",
      "jsonc",
      "lua",
      "markdown",
      "python",
      "regex",
      "rust",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "yaml",
      -- "astro",
      -- "c",
      -- "go",
      -- "gomod",
    },

    highlight = {
      enable = true,
      use_languagetree = true,
    },

    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
