local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "html",
    "css",
    "javascript",
    "json",
    "jsonc",
    "json5",
    "toml",
    "yaml",
    "markdown",
    "c",
    "bash",
    "lua",
    "astro",
    "comment",
    "dockerfile",
    "dot",
    "go",
    "gomod",
    "http",
    "javascript",
    "lua",
    "prisma",
    "python",
    "tsx",
    "regex",
    "sql",
    "typescript",
  },
}

M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.blankline = {
  filetype_exclude = {
    "help",
    "terminal",
    "alpha",
    "packer",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "nvchad_cheatsheet",
    "lsp-installer",
    "norg",
    "",
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "emmet-ls",
    "json-lsp",

    -- shell
    "shfmt",
    "shellcheck",
  },
}

return M
