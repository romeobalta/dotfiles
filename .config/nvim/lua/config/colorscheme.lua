local M = {}

---@type Palette
local original = {
  bg = "#222436",
  bg_dark = "#1e2030",
  bg_highlight = "#2f334d",
  blue = "#82aaff",
  blue0 = "#3e68d7",
  blue1 = "#65bcff",
  blue2 = "#0db9d7",
  blue5 = "#89ddff",
  blue6 = "#b4f9f8",
  blue7 = "#394b70",
  comment = "#636da6",
  cyan = "#86e1fc",
  dark3 = "#545c7e",
  dark5 = "#737aa2",
  fg = "#c8d3f5",
  fg_dark = "#828bb8",
  fg_gutter = "#3b4261",
  green = "#c3e88d",
  green1 = "#4fd6be",
  green2 = "#41a6b5",
  magenta = "#c099ff",
  magenta2 = "#ff007c",
  orange = "#ff966c",
  purple = "#fca7ea",
  red = "#ff757f",
  red1 = "#c53b53",
  teal = "#4fd6be",
  terminal_black = "#444a73",
  yellow = "#ffc777",
  git = {
    add = "#b8db87",
    change = "#7ca1f2",
    delete = "#e26a75",
  },
}

local activate_dull = function(c)
  c.bg = "#1e1e2e"
  c.bg_dark = "#171823"

  c.fg = "#cdd6f4"
  c.fg_dark = "#a0a8cd"

  c.dark_grey = "#30313c"
  c.base_text = "#cea1ae"
  c.red = "#f38ba8"
  c.blue = "#8a9cc2"
  c.orange = "#e5b799"
  c.purple = "#a38ac2"
  c.green = "#b4cea1"

  -- Generated assignments for the remaining colors
  c.bg_highlight = "#313244"
  c.fg_gutter = "#45475a"
  c.comment = "#585b70"
  c.dark3 = "#6c7086"
  c.dark5 = "#7f849c"

  c.blue0 = "#74c7ec"
  c.blue1 = "#89dceb"
  c.blue2 = "#89dceb"
  c.blue5 = "#89b4fa"
  c.blue6 = "#89dceb"
  c.blue7 = "#313244"

  c.cyan = "#89dceb"

  c.green1 = "#94e2d5"
  c.green2 = "#94e2d5"

  c.magenta = "#cba6f7"
  c.magenta2 = "#f5c2e7"

  c.red1 = "#eba0ac"

  c.teal = "#94e2d5"

  c.terminal_black = "#45475a"

  c.yellow = "#f9e2af"

  c.git = {
    add = "#a6e3a1",
    change = "#89b4fa",
    delete = "#f38ba8",
  }
end

M.on_colors = function(c)
  activate_dull(c)
end

local activate_mono = function(hl, c)
  hl.WinSeparator = { fg = "#2f334d" }
  hl.Pmenu = { fg = c.fg, bg = c.bg_dark, blend = 0 }

  hl.HarpoonInactive = { fg = c.blue7, bg = c.bg }
  hl.HarpoonNumberInactive = { fg = c.blue, bg = c.bg }
  hl.HarpoonActive = { fg = c.blue, bg = c.bg_dark }
  hl.HarpoonNumberActive = { fg = c.blue, bg = c.bg_dark }
  hl.StatusLine = { bg = c.none }
  hl.TabLine = { bg = c.none }
  hl.TabLineFill = { bg = c.none }
  hl.NvimTreeNormal = { fg = c.fg, bg = c.none }

  hl.Boolean = { fg = c.blue }
  hl.Character = { fg = c.red }
  hl.Conditional = { fg = c.purple }
  hl.Constant = { fg = c.red }
  hl.Define = { fg = c.purple }
  hl.Delimiter = { fg = c.red }
  hl.Float = { fg = c.blue }
  hl.Function = { fg = c.base_text, italic = true }
  hl.Identifier = { fg = c.red }
  hl.Include = { fg = c.purple }
  hl.Keyword = { fg = c.purple }
  hl.Label = { fg = c.blue }
  hl.Macro = { fg = c.red }
  hl.Number = { fg = c.red }
  hl.Operator = { fg = c.red }
  hl.Parameter = { fg = c.red }
  hl.PreProc = { fg = c.blue }
  hl.Repeat = { fg = c.blue }
  hl.Special = { fg = c.purple }
  hl.SpecialChar = { fg = c.red }
  hl.Statement = { fg = c.red }
  hl.StorageClass = { fg = c.blue }
  hl.String = { fg = c.orange }
  hl.Structure = { fg = c.purple }
  hl.Tag = { fg = c.red }
  hl.Todo = { fg = c.blue, bg = c.bg_dark }
  hl.Type = { fg = c.blue }
  hl.Typedef = { fg = c.blue }
  hl.Variable = { fg = c.base_text }

  hl["@annotation"] = { fg = c.red }
  hl["@attribute"] = { fg = c.blue }
  hl["@character"] = { link = "Character" }
  hl["@constant"] = { link = "Constant" }
  hl["@constant.builtin"] = { fg = c.blue }
  hl["@constant.macro"] = { link = "Macro" }
  hl["@constructor"] = { fg = c.purple }
  hl["@definition"] = { sp = c.dark_grey, underline = true }
  hl["@error"] = { fg = c.red }
  hl["@function"] = { link = "Function" }
  hl["@function.builtin"] = { link = "Function" }
  hl["@function.call"] = { link = "Function" }
  hl["@function.macro"] = { link = "Macro" }
  hl["@function.method.call"] = { link = "Function" }
  hl["@keyword"] = { link = "Keyword" }
  hl["@keyword.conditional"] = { link = "Conditional" } -- markup
  hl["@keyword.exception"] = { fg = c.red }
  hl["@keyword.exception.typescript"] = { link = "Keyword" }
  hl["@keyword.function"] = { link = "Keyword" }
  hl["@keyword.import"] = { link = "Include" }
  hl["@keyword.operator"] = { link = "Keyword" }
  hl["@keyword.return"] = { link = "Keyword" }
  hl["@lsp.type.class"] = { link = "Function" }
  hl["@lsp.type.decorator"] = { link = "Function" }
  hl["@lsp.type.enum"] = { link = "Type" }
  hl["@lsp.type.enumMember"] = { link = "Constant" }
  hl["@lsp.type.function"] = { link = "Function" }
  hl["@lsp.type.interface"] = { link = "Structure" }
  hl["@lsp.type.macro"] = { link = "Macro" }
  hl["@lsp.type.method"] = { link = "Function" }
  hl["@lsp.type.namespace"] = { link = "Type" }
  hl["@lsp.type.parameter"] = { link = "Parameter" }
  hl["@lsp.type.property"] = { link = "Variable" }
  hl["@lsp.type.struct"] = { link = "Structure" }
  hl["@lsp.type.type"] = { link = "Type" }
  hl["@lsp.type.typeParamater"] = { link = "TypeDef" }
  -- hl["@lsp.type.variable"] = { link = "Variable" }
  hl["@lsp.typemod.type.defaultLibrary"] = { link = "Type" }
  hl["@method"] = { link = "Function" }
  hl["@module"] = { fg = c.red }
  hl["@none"] = { fg = c.base_text }
  hl["@number.float"] = { fg = c.blue }
  hl["@operator"] = { link = "Operator" }
  hl["@property"] = { link = "Variable" }
  hl["@punctuation.bracket"] = { fg = c.red }
  hl["@punctuation.delimiter"] = { fg = c.red }
  hl["@punctuation.special"] = { fg = c.red }
  hl["@reference"] = { fg = c.base_text }
  hl["@scope"] = { bold = true }
  hl["@string"] = { link = "String" }
  hl["@string.escape"] = { link = "Special" }
  hl["@string.regex"] = { link = "Special" }
  hl["@string.regexp"] = { link = "Special" }
  hl["@string.special.symbol"] = { link = "String" }
  hl["@string.special.url"] = { link = "Special" }
  hl["@tag"] = { link = "Tag" }
  hl["@tag.attribute"] = { link = "Variable" }
  hl["@tag.delimiter"] = { fg = c.red }
  hl["@tag.tsx"] = { link = "Tag" }
  hl["@text"] = { fg = c.base_text }
  hl["@text.emphasis"] = { fg = c.blue }
  hl["@text.literal"] = { fg = c.blue }
  hl["@text.strike"] = { fg = c.red, strikethrough = true }
  hl["@text.strong"] = { bold = true }
  hl["@text.uri"] = { fg = c.blue, underline = true }
  hl["@type.builtin"] = { fg = c.blue }
  hl["@variable"] = { link = "Variable" }
  hl["@variable.builtin"] = { fg = c.blue }
  hl["@variable.member"] = { link = "Variable" }
  hl["@variable.member.key"] = { link = "Variable" }
  hl["@variable.parameter"] = { link = "Parameter" }

  hl["@markup.heading"] = { fg = c.purple }
  hl["@markup.raw"] = { fg = c.blue }
  hl["@markup.link"] = { fg = c.red }
  hl["@markup.link.url"] = { fg = c.blue, underline = true }
  hl["@markup.link.label"] = { fg = c.purple }
  hl["@markup.list"] = { fg = c.red }
  hl["@markup.strong"] = { bold = true }
  hl["@markup.italic"] = { italic = true }
  hl["@markup.strikethrough"] = { strikethrough = true }

  hl.NvimTreeNormal = { link = "ColorColumn" }
end

M.on_highlights = function(hl, c)
  activate_mono(hl, c)
end

return M
