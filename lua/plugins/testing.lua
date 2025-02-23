return {
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
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap", -- for the debugger
      "rcarriga/nvim-dap-ui", -- recommended
      "theHamsta/nvim-dap-virtual-text", -- recommended
      "nvim-neotest/neotest",
    },
    init = function()
      require("configs.neotest-proxy").java = "neotest-java" -- register filetypes
    end,
    opts = {},
    config = function(_, opts)
      local adapter = require "neotest-java"(opts)
      local adapters = require("neotest.config").adapters
      table.insert(adapters, adapter)
    end,
  },
  {
    "nvim-neotest/neotest-python",
    ft = "python",
    dependencies = {
      "nvim-neotest/neotest",
    },
    init = function()
      require("configs.neotest-proxy").python = "neotest-python" -- register filetype
    end,
    opts = {
      dap = { justMyCode = true },
      runner = "pytest",
      args = {
        "-s", -- don't capture console output
        "--log-level",
        "DEBUG",
        "-vv",
      },
    },
    config = function(_, opts)
      local adapter = require "neotest-python"(opts)
      local adapters = require("neotest.config").adapters
      table.insert(adapters, adapter)
    end,
  },
  {
    "andythigpen/nvim-coverage",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvzone/typr",
    cmd = {
      "Typr",
      "TyprStats",
    },
  },
}
