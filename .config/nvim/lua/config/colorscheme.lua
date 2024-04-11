local M = {}

-- colours

local activate_highcontrast = function(c)
  c.dark_grey = "#30313c"
  c.base_text = "#abb2bf"
  c.red = "#ee6d85"
  c.blue = "#7199ee"
  c.orange = "#dfae67"
  c.purple = "#a485dd"
  c.green = "#98c379"
end

local activate_dull = function(c)
  c.dark_grey = "#30313c"
  c.base_text = "#cea1ae"
  c.red = "#f38ba8"
  c.red_strong = "#f38ba8"
  c.blue = "#8a9cc2"
  -- c.orange = "#fab387"
  c.orange = "#e5b799"
  c.purple = "#a38ac2"
  c.green = "#b4cea1"
end

M.on_colors = function(c)
  c.bg = "#1e1e2e"
  c.bg_dark = "#171823"

  c.fg = "#cdd6f4"
  c.fg_dark = "#a0a8cd"

  activate_dull(c)
end

local activate_mono = function(hl, c)
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
end

M.on_highlights = function(hl, c)
  activate_mono(hl, c)
end

return M
