require "core"

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
    require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

_G.append = function()
    vim.api.nvim_feedkeys("`]a", "n", false)
end

_G.prepend = function()
    vim.api.nvim_feedkeys("`[i", "n", false)
end
