if true then
  return {}
end

return {
  "mfussenegger/nvim-dap",
  dependencies = { "nvim-neotest/nvim-nio" },

  keys = {
    {
      "<leader>dO",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
  },
}
