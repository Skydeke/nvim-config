return {
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup {
        icons = { expanded = "▾", collapsed = "▸", current_frame = "»" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>", "<TAB>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.5 },
              { id = "stacks", size = 0.3 },
              { id = "breakpoints", size = 0.10 },
              { id = "watches", size = 0.10 },
            },
            position = "left",
            size = 30,
          },
          {
            elements = {
              { id = "console", size = 0.8 },
              { id = "repl", size = 0.2 },
            },
            position = "bottom",
            size = 20,
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true, -- because the icons don't work
          -- Display controls in this element
          element = "console",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        windows = { indent = 1 },
      }

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        vim.cmd "NvimTreeClose"
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
        require("nvim-tree.api").tree.toggle { path = "", find_file = false, update_root = false, focus = false }
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
        require("nvim-tree.api").tree.toggle { path = "", find_file = false, update_root = false, focus = false }
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      require "configs.dap"
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      require("dap-python").setup "python"
    end,
  },
}
