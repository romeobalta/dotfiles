return {
  "folke/tokyonight.nvim",
  opts = {
    style = "storm",
    on_colors = function(c)
      c.base00 = "#1e1e2e"
      c.base01 = "#1b1c27"
      c.base02 = "#545560"
      c.base03 = "#282934"
      c.base04 = "#30313c"
      c.base05 = "#abb2bf"
      c.base06 = "#b2b9c6"
      c.base07 = "#A0A8CD"
      c.base08 = "#ee6d85"
      c.base09 = "#7199ee"
      c.base0A = "#7199ee"
      c.base0B = "#dfae67"
      c.base0C = "#a485dd"
      c.base0D = "#98c379"
      c.base0E = "#a485dd"
      c.base0F = "#f3627a"

      c.red = c.base0F
      c.green = c.base0D
      c.blue = c.base0A
    end,
    on_highlights = function(hl, c)
      hl.HarpoonInactive = {
        fg = c.blue7,
        bg = c.bg_dark,
      }
      hl.HarpoonNumberInactive = {
        fg = c.blue,
      }
      hl.HarpoonActive = {
        fg = c.green2,
        bg = c.bg_light,
      }
      hl.HarpoonNumberActive = {
        fg = c.blue,
        bg = c.bg_light,
      }

      if true then
        hl.Boolean = {
          fg = c.base09,
        }
        hl.Character = {
          fg = c.base08,
        }
        hl.Conditional = {
          fg = c.base0E,
        }
        hl.Constant = {
          fg = c.base08,
        }
        hl.Define = {
          fg = c.base0E,
          sp = "none",
        }
        hl.Delimiter = {
          fg = c.base0F,
        }
        hl.Float = {
          fg = c.base09,
        }
        hl.Variable = {
          fg = c.base05,
        }
        hl.Function = {
          fg = c.base0D,
        }
        hl.Identifier = {
          fg = c.base08,
          sp = "none",
        }
        hl.Include = {
          fg = c.base0D,
        }
        hl.Keyword = {
          fg = c.base0E,
        }
        hl.Label = {
          fg = c.base0A,
        }
        hl.Number = {
          fg = c.base09,
        }
        hl.Operator = {
          fg = c.base05,
          sp = "none",
        }
        hl.PreProc = {
          fg = c.base0A,
        }
        hl.Repeat = {
          fg = c.base0A,
        }
        hl.Special = {
          fg = c.base0C,
        }
        hl.SpecialChar = {
          fg = c.base0F,
        }
        hl.Statement = {
          fg = c.base08,
        }
        hl.StorageClass = {
          fg = c.base0A,
        }
        hl.String = {
          fg = c.base0B,
        }
        hl.Structure = {
          fg = c.base0E,
        }
        hl.Tag = {
          fg = c.base0A,
        }
        hl.Todo = {
          fg = c.base0A,
          bg = c.base01,
        }
        hl.Type = {
          fg = c.base0A,
          sp = "none",
        }
        hl.Typedef = {
          fg = c.base0A,
        }
        hl["@lsp.type.class"] = { link = "Structure" }
        hl["@lsp.type.decorator"] = { link = "Function" }
        hl["@lsp.type.enum"] = { link = "Type" }
        hl["@lsp.type.enumMember"] = { link = "Constant" }
        hl["@lsp.type.function"] = { link = "@function" }
        hl["@lsp.type.interface"] = { link = "Structure" }
        hl["@lsp.type.macro"] = { link = "@macro" }
        hl["@lsp.type.method"] = { link = "@method" }
        hl["@lsp.type.namespace"] = { link = "@module" }
        hl["@lsp.type.parameter"] = { link = "@variable.parameter" }
        hl["@lsp.type.property"] = { link = "@property" }
        hl["@lsp.type.struct"] = { link = "Structure" }
        hl["@lsp.type.type"] = { link = "@type" }
        hl["@lsp.type.typeParamater"] = { link = "TypeDef" }
        hl["@lsp.type.variable"] = { link = "@variable" }
        hl["@annotation"] = {
          fg = c.base0F,
        }
        hl["@attribute"] = {
          fg = c.base0A,
        }
        hl["@character"] = {
          fg = c.base08,
        }
        hl["@constructor"] = {
          fg = c.base0C,
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
          fg = c.base0E,
        }
        hl["@keyword.function"] = {
          fg = c.base0E,
        }
        hl["@keyword.return"] = {
          fg = c.base0E,
        }
        hl["@function"] = {
          fg = c.base0D,
        }
        hl["@function.builtin"] = {
          fg = c.base0D,
        }
        hl["@function.macro"] = {
          fg = c.base08,
        }
        hl["@function.call"] = {
          fg = c.base0D,
        }
        hl["@operator"] = {
          fg = c.base05,
        }
        hl["@keyword.operator"] = {
          fg = c.base0E,
        }
        hl["@method"] = {
          fg = c.base0D,
        }
        hl["@function.method.call"] = {
          fg = c.base0D,
        }
        hl["@module"] = {
          fg = c.base08,
        }
        hl["@none"] = {
          fg = c.base05,
        }
        hl["@variable.parameter"] = {
          fg = c.base05,
        }
        hl["@reference"] = {
          fg = c.base05,
        }
        hl["@punctuation.bracket"] = {
          fg = c.base0F,
        }
        hl["@punctuation.delimiter"] = {
          fg = c.base0F,
        }
        hl["@string"] = {
          fg = c.base0B,
        }
        hl["@string.regex"] = {
          fg = c.base0C,
        }
        hl["@string.escape"] = {
          fg = c.base0C,
        }
        hl["@string.special.url"] = {
          fg = c.base0C,
        }
        hl["@string.special.symbol"] = {
          fg = c.base0B,
        }
        hl["@tag"] = {
          link = "Tag",
        }
        hl["@tag.attribute"] = {
          link = "@property",
        }
        hl["@tag.delimiter"] = {
          fg = c.base0F,
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
          fg = c.base0F,
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
          fg = c.base0A,
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
        hl["@markup.heading"] = { fg = c.base0D }
        hl["@markup.raw"] = { fg = c.base09 }
        hl["@markup.link"] = { fg = c.base08 }
        hl["@markup.link.url"] = { fg = c.base09, underline = true }
        hl["@markup.link.label"] = { fg = c.base0C }
        hl["@markup.list"] = { fg = c.base08 }
        hl["@markup.strong"] = { bold = true }
        hl["@markup.italic"] = { italic = true }
        hl["@markup.strikethrough"] = { strikethrough = true }
      end
    end,
  },
}
