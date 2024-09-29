local dap = require "dap"

require("dap.ext.vscode").load_launchjs()

dap.adapters.cpp = {
  name = "codelldb server",
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}
