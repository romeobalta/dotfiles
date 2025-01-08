return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion.ghost_text = {
      enabled = false,
    }

    opts.signature = {
      enabled = true,
    }

    opts.keymap.preset = "super-tab"
  end,
}
