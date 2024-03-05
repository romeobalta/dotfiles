local tokyodark = require("config.tokyodark")

return {
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    on_colors = tokyodark.on_colors,
    on_highlights = tokyodark.on_highlights,
  },
}
