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

-- Java-Adapter is loaded by nvim-java require(java).setup

-- Create the target directory if it doesn't exist
local target_dir = "target"
local function ensure_target_directory()
  local target_path = vim.fn.getcwd() .. "/" .. target_dir
  if vim.fn.isdirectory(target_path) == 0 then
    vim.fn.mkdir(target_path, "p")
  end
  return target_path
end

-- Function to update `cwd` in a configuration only if it wasn't already set
local function set_cwd_in_configurations(configs)
  for _, config in ipairs(configs) do
    if not config.cwd then -- Only set cwd if it wasn't already configured
      config.cwd = ensure_target_directory()
    end
  end
end

-- Wrap dap.configurations in a proxy to detect changes
local original_configurations = dap.configurations

dap.configurations = setmetatable({}, {
  __newindex = function(t, lang, configs)
    -- When new configurations are added, update cwd and store them
    set_cwd_in_configurations(configs)
    rawset(t, lang, configs)
    vim.notify("DAP configurations updated for " .. lang .. " with cwd set to target folder", vim.log.levels.INFO)
  end,
  __index = function(t, key)
    return rawget(original_configurations, key)
  end,
})

-- Initially update cwd in existing configurations
for lang, configs in pairs(original_configurations) do
  set_cwd_in_configurations(configs)
end
