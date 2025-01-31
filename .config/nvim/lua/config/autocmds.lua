-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd = vim.api.nvim_create_autocmd

local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Highlight some special panes
local special_pane_ns = vim.api.nvim_create_namespace("SpecialPane")
vim.api.nvim_set_hl(special_pane_ns, "BackgroundSpecial", { bg = "#1b1d2b" })
vim.api.nvim_set_hl(special_pane_ns, "Normal", { link = "BackgroundSpecial" })
autocmd("FileType", {
  pattern = "Avante*",
  callback = function()
    vim.api.nvim_win_set_hl_ns(0, special_pane_ns)
  end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.mdx",
  callback = function()
    vim.bo.filetype = "markdown.mdx"
  end,
})

local dap = require("dap")
-- remove dapui_config from event_terminated
dap.listeners.before.event_terminated["dapui_config"] = nil
dap.listeners.before.event_exited["dapui_config"] = nil

-- some zig fixes
vim.api.nvim_set_hl(0, "@lsp.type.string.zig", {})
