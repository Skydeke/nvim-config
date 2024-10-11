return {
  {
    "atm1020/neotest-jdtls",
    ft = "java",
    dependencies = {
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-neotest/neotest",
    },
  },
  -- {
  --   "rcasia/neotest-java",
  --   ft = "java",
  --   dependencies = {
  --     "mfussenegger/nvim-jdtls",
  --     "mfussenegger/nvim-dap", -- for the debugger
  --     "rcarriga/nvim-dap-ui", -- recommended
  --     "theHamsta/nvim-dap-virtual-text", -- recommended
  --     "nvim-neotest/neotest",
  --   },
  -- },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require "configs.neotest"
    end,
  },
}
