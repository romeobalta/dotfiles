local keys = {
  {
    "<C-w>",
    function()
      require("copilot.suggestion").accept_word()
      print("copilot")
    end,
    desc = " accept word suggestion",
    mode = "i",
  },
  {
    "<C-l>",
    function()
      require("copilot.suggestion").accept_line()
    end,
    desc = " accept line suggestion",
    mode = "i",
  },
  {
    "<C-k>",
    function()
      require("copilot.suggestion").next()
    end,
    desc = " next suggestion",
    mode = "i",
  },
  {
    "<C-j>",
    function()
      require("copilot.suggestion").prev()
    end,
    desc = " prev suggestion",
    mode = "i",
  },
  {
    "<C-h>",
    function()
      require("copilot.suggestion").dismiss()
    end,
    desc = " dismiss suggestion",
    mode = "i",
  },
  {
    "<Tab>",
    function()
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      else
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
      end
    end,
    desc = " accept suggestion",
    mode = "i",
  },
  {
    "<C-p>",
    function()
      require("copilot.panel").open({
        "bottom",
        0.4,
      })
    end,
    desc = " open suggestion panel",
    mode = "i",
  },
}

return {
  "zbirenbaum/copilot.lua",
  keys = keys,
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
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
        accept = "<CR>",
        refresh = "<C-r>",
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
  end,
}