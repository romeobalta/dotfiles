return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- find
    { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>fr", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },

    -- search
    { "<leader><space>", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>fs", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>fS", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>sw", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
    { "<leader>sw", LazyVim.pick("grep_string", { root = false }), mode = "v", desc = "Selection (cwd)" },

    { "<leader>/", false },
    { "<leader>fb", false },
    { "<leader>sW", false },
    { "<leader>sG", false },
    { "<leader>fF", false },
    { "<leader>fR", false },
  },
}
