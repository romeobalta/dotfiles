return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  build = ":Copilot auth",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = false,
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = false,
      },
    },

    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = "<C-k>",
        jump_next = "<C-j>",
      },
    },

    filetypes = {
      lua = true,

      typescript = true,
      typescriptreact = true,
      javascript = true,
      javascriptreact = true,
      json = true,
      yaml = true,

      go = true,
      rust = true,

      python = true,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)

    vim.keymap.set("i", "<C-w>", function()
      require("copilot.suggestion").accept_word()
    end, { desc = " accept word suggestion" })

    vim.keymap.set("i", "<C-l>", function()
      require("copilot.suggestion").accept_line()
    end, { desc = " accept line suggestion" })

    vim.keymap.set("i", "<C-k>", function()
      require("copilot.suggestion").next()
    end, { desc = " next suggestion" })

    vim.keymap.set("i", "<C-j>", function()
      require("copilot.suggestion").prev()
    end, { desc = " prev suggestion" })

    vim.keymap.set("i", "<C-h>", function()
      require("copilot.suggestion").dismiss()
    end, { desc = " dismiss suggestion" })

    vim.keymap.set("i", "<C-p>", function()
      require("copilot.panel").open({
        "bottom",
        0.4,
      })
    end, { desc = " open suggestion panel" })
  end,
}
