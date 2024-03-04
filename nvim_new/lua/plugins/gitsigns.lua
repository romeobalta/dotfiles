return {
  "lewis6991/gitsigns.nvim",

  keys = {
    {
      "g]",
      function()
        if vim.wo.diff then
          return "c]"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      desc = "Jump to next hunk",
      opts = { expr = true },
    },

    {
      "g[",
      function()
        if vim.wo.diff then
          return "c["
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      desc = "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions on hunks
    {
      "<leader>gr",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Reset hunk",
    },

    {
      "<leader>gp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview hunk",
    },

    {
      "<leader>gb",
      function()
        package.loaded.gitsigns.blame_line()
      end,
      desc = "Blame line",
    },
  },

  ft = { "gitcommit", "diff" },
  init = function()
    -- load gitsigns only when a git file is opened
    vim.api.nvim_create_autocmd({ "BufRead" }, {
      group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
      callback = function()
        vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
        if vim.v.shell_error == 0 then
          vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
          vim.schedule(function()
            require("lazy").load({ plugins = { "gitsigns.nvim" } })
          end)
        end
      end,
    })
  end,

  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "│" },
    },
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)
  end,
}
