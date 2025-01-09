-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

-- opt.guicursor = ""

g.snacks_animate = false
g.mapleader = " "
g.maplocalleader = " "

g.copilot_no_maps = true

-------------------------------------- options ------------------------------------------
opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.tabstop = 8
opt.softtabstop = 0
opt.shiftwidth = 4
--
-- opt.relativenumber = false

-- disable nvim intro
-- opt.shortmess:append("sI")

-- opt.swapfile = false
-- opt.backup = false

opt.scrolloff = 24
opt.colorcolumn = "100"

-- opt.wrap = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25

function HighlightedFoldtext()
  local start_pos = vim.v.foldstart
  local end_pos = vim.v.foldend
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  local parser = vim.treesitter.get_parser(0, lang)
  local query = vim.treesitter.query.get(parser:lang(), "highlights")
  local line_count = end_pos - start_pos - 1

  if query == nil then
    return vim.fn.foldtext()
  end

  local function get_highlighted_line(pos)
    local tree = parser:parse({ pos - 1, pos })[1]
    local result = {}

    local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]
    local line_pos = 0

    local prev_range = nil

    for id, node, _ in query:iter_captures(tree:root(), 0, pos - 1, pos) do
      local name = query.captures[id]
      local start_row, start_col, end_row, end_col = node:range()
      if start_row == pos - 1 and end_row == pos - 1 then
        local range = { start_col, end_col }
        if start_col > line_pos then
          table.insert(result, { line:sub(line_pos + 1, start_col), "Folded" })
        end
        line_pos = end_col
        local text = vim.treesitter.get_node_text(node, 0)
        if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
          result[#result] = { text, "@" .. name }
        else
          table.insert(result, { text, "@" .. name })
        end
        prev_range = range
      end
    end

    return result
  end

  local result = get_highlighted_line(start_pos)

  local end_line = get_highlighted_line(end_pos)

  local line_count_noun = line_count == 1 and "line" or "lines"

  table.insert(result, { string.format(" ... %d " .. line_count_noun .. " ", line_count), "FoldedComment" })

  -- check if the first element in the end_line contains only whitespace in the first position
  -- and Folded in the second position, then remove it
  if end_line[1][1]:match("^%s") and end_line[1][2] == "Folded" then
    table.remove(end_line, 1)
  end

  for _, segment in ipairs(end_line) do
    table.insert(result, segment)
  end

  return result
end

opt.foldtext = [[luaeval('HighlightedFoldtext')()]]
