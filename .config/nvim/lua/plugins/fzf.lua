return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader>/", false },
    { "<leader>fb", false },

    { "<leader><space>", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>fs", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    { "<leader>fS", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>fl", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
  },

  opts = function(_, opts)
    opts.fzf_opts = {
      ["--layout"] = "default",
    }
  end,
}
