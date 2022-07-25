local M = {}

M.custom = {
  n = {
    ["<leader>bd"] = { "<cmd> :bp | bd# <CR>", "close current buffer", opts = {} },
  },

  i = {
    ["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true }},
  },
}

return M
