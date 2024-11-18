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
          require("snacks.notify").info("Using model: " .. require("CopilotChat").config.model)
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
