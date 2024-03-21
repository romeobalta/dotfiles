local tokyodark = require("config.colorscheme")

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      on_colors = tokyodark.on_colors,
      on_highlights = tokyodark.on_highlights,
    },
  },
}
