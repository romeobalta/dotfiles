if true then
  return {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "gpt-4o-2024-08-06",
      mappings = {
        reset = {
          normal = "<C-x>",
          insert = "<C-x>",
        },
      },
    },
    keys = {
      {
        "<leader>am",
        function()
          vim.notify("Using model: " .. require("CopilotChat").config.model, vim.log.levels.INFO)
        end,
        desc = "Select Model (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>a?",
        function()
          return require("CopilotChat").select_model()
        end,
        desc = "Select Model (CopilotChat)",
        mode = { "n", "v" },
      },
    },
  }
end

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      auto_suggestions_provider = "copilot",
      behaviour = {
        auto_suggestions = false, -- Experimental stage
      },
      hints = {
        enabled = false,
      },
      mappings = {
        suggestion = {
          -- accept = "<C-l>",
          -- dismiss = "<C-h>",
        },
      },
      windows = {
        sidebar_header = {
          rounded = false,
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
