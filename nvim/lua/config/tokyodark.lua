local M = {}

M.on_colors = function(c)
  c.base00 = "#1e1e2e"
  c.base01 = "#1b1c27"
  c.base02 = "#545560"
  c.base03 = "#282934"
  c.base04 = "#30313c"
  c.base05 = "#abb2bf"
  c.base06 = "#b2b9c6"
  c.base07 = "#a9b1d6"
  c.base08 = "#ee6d85"
  c.base09 = "#7199ee"
  c.base10 = "#7199ee"
  c.base11 = "#dfae67"
  c.base12 = "#a485dd"
  c.base13 = "#38a89d"
  c.base14 = "#a485dd"
  c.base15 = "#f3627a"

  c.red = c.base15
  c.green = c.base13
  c.blue = c.base10

  c.bg = c.base00
  c.bg_dark = "#171823"

  c.fg = c.base07
  c.fg_dark = "#A0A8CD"
end

M.on_highlights = function(hl, c)
  hl.HarpoonInactive = {
    fg = c.blue7,
  }
  hl.HarpoonNumberInactive = {
    fg = c.blue,
    bg = c.bg_light,
  }
  hl.HarpoonActive = {
    fg = c.base09,
    bg = c.bg_dark,
  }
  hl.HarpoonNumberActive = {
    fg = c.blue,
    bg = c.bg_dark,
  }
  hl.StatusLine = {
    bg = c.none,
  }
  hl.TabLine = {
    bg = c.none,
  }
  hl.TabLineFill = {
    bg = c.none,
  }
  hl.NvimTreeNormal = {
    fg = c.base07,
    bg = c.none,
  }

  if true then
    hl.Boolean = {
      fg = c.base09,
    }
    hl.Character = {
      fg = c.base08,
    }
    hl.Conditional = {
      fg = c.base14,
    }
    hl.Constant = {
      fg = c.base08,
    }
    hl.Define = {
      fg = c.base14,
      sp = "none",
    }
    hl.Delimiter = {
      fg = c.base15,
    }
    hl.Float = {
      fg = c.base09,
    }
    hl.Variable = {
      fg = c.base05,
    }
    hl.Function = {
      fg = c.base13,
    }
    hl.Identifier = {
      fg = c.base08,
      sp = "none",
    }
    hl.Include = {
      fg = c.base14,
    }
    hl.Keyword = {
      fg = c.base14,
    }
    hl.Label = {
      fg = c.base10,
    }
    hl.Number = {
      fg = c.base09,
    }
    hl.Operator = {
      fg = c.base05,
      sp = "none",
    }
    hl.PreProc = {
      fg = c.base10,
    }
    hl.Repeat = {
      fg = c.base10,
    }
    hl.Special = {
      fg = c.base12,
    }
    hl.SpecialChar = {
      fg = c.base15,
    }
    hl.Statement = {
      fg = c.base08,
    }
    hl.StorageClass = {
      fg = c.base10,
    }
    hl.String = {
      fg = c.base11,
    }
    hl.Structure = {
      fg = c.base14,
    }
    hl.Tag = {
      fg = c.base10,
    }
    hl.Todo = {
      fg = c.base10,
      bg = c.base01,
    }
    hl.Type = {
      fg = c.base10,
      sp = "none",
    }
    hl.Typedef = {
      fg = c.base10,
    }

    hl["@lsp.type.class"] = { link = "Structure" }
    hl["@lsp.type.decorator"] = { link = "Function" }
    hl["@lsp.type.enum"] = { link = "Type" }
    hl["@lsp.type.enumMember"] = { link = "Constant" }
    hl["@lsp.type.function"] = { link = "@function" }
    hl["@lsp.type.interface"] = { link = "Structure" }
    hl["@lsp.type.macro"] = { link = "@macro" }
    hl["@lsp.type.method"] = { link = "@method" }
    hl["@lsp.type.namespace"] = { link = "@type" }
    hl["@lsp.type.parameter"] = { link = "@variable.parameter" }
    hl["@lsp.type.property"] = { link = "@property" }
    hl["@lsp.type.struct"] = { link = "Structure" }
    hl["@lsp.type.type"] = { link = "@type" }
    hl["@lsp.type.typeParamater"] = { link = "TypeDef" }
    hl["@lsp.type.variable"] = { link = "@variable" }

    hl["@annotation"] = {
      fg = c.base15,
    }
    hl["@attribute"] = {
      fg = c.base10,
    }
    hl["@character"] = {
      fg = c.base08,
    }
    hl["@constructor"] = {
      fg = c.base12,
    }
    hl["@constant"] = {
      fg = c.base08,
    }
    hl["@constant.builtin"] = {
      fg = c.base09,
    }
    hl["@constant.macro"] = {
      fg = c.base08,
    }
    hl["@error"] = {
      fg = c.base08,
    }
    hl["@keyword.exception"] = {
      fg = c.base08,
    }
    hl["@number.float"] = {
      fg = c.base09,
    }
    hl["@keyword"] = {
      fg = c.base14,
    }
    hl["@keyword.function"] = {
      fg = c.base14,
    }
    hl["@keyword.return"] = {
      fg = c.base14,
    }
    hl["@function"] = {
      fg = c.base13,
    }
    hl["@function.builtin"] = {
      fg = c.base13,
    }
    hl["@function.macro"] = {
      fg = c.base08,
    }
    hl["@function.call"] = {
      fg = c.base13,
    }
    hl["@operator"] = {
      fg = c.base05,
    }
    hl["@keyword.operator"] = {
      fg = c.base14,
    }
    hl["@method"] = {
      fg = c.base13,
    }
    hl["@function.method.call"] = {
      fg = c.base13,
    }
    hl["@module"] = {
      fg = c.base08,
    }
    hl["@none"] = {
      fg = c.base05,
    }
    hl["@variable.parameter"] = {
      fg = c.blue5,
    }
    hl["@reference"] = {
      fg = c.base05,
    }
    hl["@punctuation.bracket"] = {
      fg = c.base15,
    }
    hl["@punctuation.delimiter"] = {
      fg = c.base15,
    }
    hl["@punctuation.special"] = {
      fg = c.base08,
    }

    hl["@string"] = {
      fg = c.base11,
    }
    hl["@string.regex"] = {
      fg = c.base12,
    }
    hl["@string.escape"] = {
      fg = c.base12,
    }
    hl["@string.special.url"] = {
      fg = c.base12,
    }
    hl["@string.special.symbol"] = {
      fg = c.base11,
    }
    hl["@tag"] = {
      link = "Tag",
    }
    hl["@tag.attribute"] = {
      link = "@property",
    }
    hl["@tag.delimiter"] = {
      fg = c.base15,
    }
    hl["@text"] = {
      fg = c.base05,
    }
    hl["@text.strong"] = {
      bold = true,
    }
    hl["@text.emphasis"] = {
      fg = c.base09,
    }
    hl["@text.strike"] = {
      fg = c.base15,
      strikethrough = true,
    }
    hl["@text.literal"] = {
      fg = c.base09,
    }
    hl["@text.uri"] = {
      fg = c.base09,
      underline = true,
    }
    hl["@type.builtin"] = {
      fg = c.base10,
    }
    hl["@variable"] = {
      fg = c.base05,
    }
    hl["@variable.builtin"] = {
      fg = c.base09,
    }
    hl["@definition"] = {
      sp = c.base04,
      underline = true,
    }
    hl["@scope"] = {
      bold = true,
    }
    hl["@variable.member"] = {
      fg = c.base08,
    }
    hl["@variable.member.key"] = {
      fg = c.base08,
    }
    hl["@property"] = {
      fg = c.base08,
    }
    hl["@keyword.import"] = {
      link = "Include",
    }
    hl["@keyword.conditional"] = {
      link = "Conditional",
    }
    -- markup
    hl["@markup.heading"] = { fg = c.base14 }
    hl["@markup.raw"] = { fg = c.base09 }
    hl["@markup.link"] = { fg = c.base08 }
    hl["@markup.link.url"] = { fg = c.base09, underline = true }
    hl["@markup.link.label"] = { fg = c.base12 }
    hl["@markup.list"] = { fg = c.base08 }
    hl["@markup.strong"] = { bold = true }
    hl["@markup.italic"] = { italic = true }
    hl["@markup.strikethrough"] = { strikethrough = true }
  end
end

return M