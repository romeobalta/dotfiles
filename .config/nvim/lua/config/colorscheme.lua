local M = {}

local activate_dull = function(c)
  c.bg = "#1a1b26"
  c.bg_dark = "#16161e"
  c.bg_highlight = "#292e42"
  c.fg = "#c0caf5"
  c.fg_dark = "#a9b1d6"
  c.fg_code = "#cea1ae"
  c.fg_code_dark = "#af8994"
  c.fg_gutter = "#3b4261"
  c.dark3 = "#6c7086"
  c.dark5 = "#7f849c"
  c.comment = "#565f89"
  c.terminal_black = "#414868"
  c.blue = "#8a9cc2"
  c.blue0 = "#3d59a1"
  c.blue1 = "#7aa2f7"
  c.blue2 = "#89ddff"
  c.blue5 = "#0db9d7"
  c.blue6 = "#b4f9f8"
  c.blue7 = "#394b70"
  c.cyan = "#7dcfff"
  c.green = "#b4cea1"
  c.green1 = "#addad7"
  c.green2 = "#71a5b5"
  c.magenta = "#cba6f7"
  c.magenta2 = "#e91f70"
  c.purple = "#a38ac2"
  c.yellow = "#f9e2af"
  c.orange = "#e5b799"
  c.red = "#f38ba8"
  c.red1 = "#eba0ac"
  c.teal = "#d0e2e0"
  c.git = {
    add = "#9ece6a",
    change = "#7aa2f7",
    delete = "#f7768e",
  }
end

M.on_colors = function(c)
  activate_dull(c)
end

local activate_mono = function(hl, c)
  hl.WinSeparator = { fg = c.fg_gutter }
  hl.Pmenu = { fg = c.fg, bg = c.bg_dark, blend = 0 }
  hl.SpecialBorder = { fg = c.fg_gutter }
  hl.CursorLine = { bg = c.bg }
  hl.IblIndent = { fg = "#1b1d2b" }
  hl.IblScope = { fg = c.bg_highlight }

  hl.CmpItemKind = { fg = c.comment }
  hl.CmpItemKindArray = { fg = c.comment }
  hl.CmpItemKindBoolean = { fg = c.comment }
  hl.CmpItemKindClass = { fg = c.comment }
  hl.CmpItemKindCodeium = { fg = c.comment }
  hl.CmpItemKindColor = { fg = c.comment }
  hl.CmpItemKindConstant = { fg = c.comment }
  hl.CmpItemKindConstructor = { fg = c.comment }
  hl.CmpItemKindCopilot = { fg = c.comment }
  hl.CmpItemKindDefault = { fg = c.comment }
  hl.CmpItemKindEnum = { fg = c.comment }
  hl.CmpItemKindEnumMember = { fg = c.comment }
  hl.CmpItemKindEvent = { fg = c.comment }
  hl.CmpItemKindField = { fg = c.comment }
  hl.CmpItemKindFile = { fg = c.comment }
  hl.CmpItemKindFolder = { fg = c.comment }
  hl.CmpItemKindFunction = { fg = c.comment }
  hl.CmpItemKindInterface = { fg = c.comment }
  hl.CmpItemKindKey = { fg = c.comment }
  hl.CmpItemKindKeyword = { fg = c.comment }
  hl.CmpItemKindMethod = { fg = c.comment }
  hl.CmpItemKindModule = { fg = c.comment }
  hl.CmpItemKindNamespace = { fg = c.comment }
  hl.CmpItemKindNull = { fg = c.comment }
  hl.CmpItemKindNumber = { fg = c.comment }
  hl.CmpItemKindObject = { fg = c.comment }
  hl.CmpItemKindOperator = { fg = c.comment }
  hl.CmpItemKindPackage = { fg = c.comment }
  hl.CmpItemKindProperty = { fg = c.comment }
  hl.CmpItemKindReference = { fg = c.comment }
  hl.CmpItemKindSnippet = { fg = c.comment }
  hl.CmpItemKindString = { fg = c.comment }
  hl.CmpItemKindStruct = { fg = c.comment }
  hl.CmpItemKindSupermaven = { fg = c.comment }
  hl.CmpItemKindTabNine = { fg = c.comment }
  hl.CmpItemKindText = { fg = c.comment }
  hl.CmpItemKindTypeParameter = { fg = c.comment }
  hl.CmpItemKindUnit = { fg = c.comment }
  hl.CmpItemKindValue = { fg = c.comment }
  hl.CmpItemKindVariable = { fg = c.comment }

  hl.TelescopeNormal = {
    bg = c.bg_dark,
    fg = c.fg_dark,
  }
  hl.TelescopeTitle = {
    bg = c.bg_dark,
    fg = c.fg_dark,
  }
  hl.TelescopeBorder = {
    bg = c.bg_dark,
    fg = c.fg_gutter,
  }
  hl.TelescopePromptTitle = {
    bg = c.bg_dark,
    fg = c.fg_gutter,
  }
  hl.TelescopePromptBorder = {
    bg = c.bg_dark,
    fg = c.fg_gutter,
  }

  hl.HarpoonInactive = { fg = c.blue7, bg = c.bg }
  hl.HarpoonNumberInactive = { fg = c.blue, bg = c.bg }
  hl.HarpoonActive = { fg = c.blue, bg = c.bg_dark }
  hl.HarpoonNumberActive = { fg = c.blue, bg = c.bg_dark }
  hl.StatusLine = { bg = c.none }
  hl.TabLine = { bg = c.none }
  hl.TabLineFill = { bg = c.none }
  hl.NvimTreeNormal = { fg = c.fg, bg = c.none }

  hl.Boolean = { fg = c.blue }
  hl.Character = { fg = c.yellow }
  hl.Conditional = { fg = c.purple }
  hl.Constant = { fg = c.red }
  hl.Define = { fg = c.purple }
  hl.Delimiter = { fg = c.red }
  hl.Float = { fg = c.blue }
  hl.Function = { fg = c.fg_code, italic = true }
  hl.Identifier = { fg = c.red }
  hl.Include = { fg = c.purple }
  hl.Keyword = { fg = c.purple }
  hl.Label = { fg = c.blue }
  hl.Macro = { fg = c.red }
  hl.Number = { fg = c.red }
  hl.Operator = { fg = c.red }
  hl.Parameter = { fg = c.red }
  hl.Punctuation = { fg = c.red }
  hl.PreProc = { fg = c.blue }
  hl.Repeat = { fg = c.purple }
  hl.Special = { fg = "#7aa2f7" }
  hl.SpecialChar = { fg = c.red }
  hl.Statement = { fg = c.red }
  hl.StorageClass = { fg = c.blue }
  hl.String = { fg = c.orange }
  hl.Structure = { fg = c.purple }
  hl.Tag = { fg = c.red }
  hl.Todo = { fg = c.blue, bg = c.bg_dark }
  hl.Type = { fg = c.blue }
  hl.Typedef = { fg = c.blue }
  hl.Variable = { fg = c.fg_code }

  hl["@annotation"] = { fg = c.red }
  hl["@attribute"] = { fg = c.blue }
  hl["@character"] = { link = "Character" }
  hl["@constant"] = { link = "Constant" }
  hl["@constant.builtin"] = { link = "Type" }
  hl["@constant.macro"] = { link = "Macro" }
  hl["@constructor"] = { link = "Type" }
  hl["@definition"] = { sp = c.terminal_black, underline = true }
  hl["@error"] = { fg = c.red }
  hl["@function"] = { link = "Function" }
  hl["@function.builtin"] = { link = "Function" }
  hl["@function.call"] = { link = "Function" }
  hl["@function.macro"] = { link = "Macro" }
  hl["@function.method.call"] = { link = "Function" }
  hl["@keyword"] = { link = "Keyword" }
  hl["@keyword.conditional"] = { link = "Conditional" }
  hl["@keyword.exception"] = { fg = c.red }
  hl["@keyword.exception.typescript"] = { link = "Keyword" }
  hl["@keyword.function"] = { link = "Keyword" }
  hl["@keyword.import"] = { link = "Include" }
  hl["@keyword.operator"] = { link = "Keyword" }
  hl["@keyword.return"] = { link = "Keyword" }
  hl["@keyword.repeat"] = { link = "Repeat" }
  hl["@method"] = { link = "Function" }
  hl["@module"] = { link = "Type" }
  hl["@none"] = { fg = c.fg }
  hl["@number.float"] = { link = "Number" }
  hl["@operator"] = { link = "Operator" }
  hl["@property"] = { link = "Variable" }
  hl["@punctuation"] = { link = "Punctuation" }
  hl["@punctuation.bracket"] = { link = "Punctuation" }
  hl["@punctuation.delimiter"] = { link = "Punctuation" }
  hl["@punctuation.special"] = { link = "Punctuation" }
  hl["@reference"] = { fg = c.fg }
  hl["@scope"] = { bold = true }
  hl["@string"] = { link = "String" }
  hl["@string.escape"] = { link = "SpecialChar" }
  hl["@string.regex"] = { link = "Special" }
  hl["@string.regexp"] = { link = "Special" }
  hl["@string.special.symbol"] = { link = "String" }
  hl["@string.special.url"] = { fg = c.blue, underline = true }
  hl["@tag"] = { link = "Tag" }
  hl["@tag.builtin"] = { link = "Tag" }
  hl["@tag.attribute"] = { link = "Variable" }
  hl["@tag.delimiter"] = { link = "Delimiter" }
  hl["@tag.tsx"] = { link = "Tag" }
  hl["@text"] = { fg = c.fg }
  hl["@text.emphasis"] = { fg = c.blue }
  hl["@text.literal"] = { fg = c.blue }
  hl["@text.strike"] = { fg = c.red, strikethrough = true }
  hl["@text.strong"] = { bold = true }
  hl["@text.uri"] = { fg = c.blue, underline = true }
  hl["@type.builtin"] = { fg = c.blue }
  hl["@variable"] = { link = "Variable" }
  hl["@variable.builtin"] = { link = "Type" }
  hl["@variable.member"] = { link = "Variable" }
  hl["@variable.member.key"] = { link = "Variable" }
  hl["@variable.parameter"] = { link = "Parameter" }

  hl["@lsp.type.class"] = { link = "Type" }
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
  hl["@lsp.type.variable"] = { link = "Variable" }
  hl["@lsp.typemod.type.defaultLibrary"] = { link = "Type" }

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
