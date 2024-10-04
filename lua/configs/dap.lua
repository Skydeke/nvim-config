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

local function setup_debugger_mappings(bufnr)
  local dap = require "dap"

  -- Check if the current buffer has a DAP configuration
  local configurations = dap.configurations[vim.bo.filetype]
  if configurations and #configurations > 0 then
    -- Define your keybindings
    local debugger_mappings = {
      n = {
        -- LSP Diagnostics
        ["<leader>do"] = {
          function()
            require("dapui").open()
          end,
          { desc = "Open DAP-UI" },
        },
        ["<leader>dc"] = {
          function()
            require("dapui").close()
          end,
          { desc = "Close DAP-UI" },
        },
      },
    }

    -- Set the keybindings with options
    local opts = { buffer = bufnr, silent = true }
    for mode, maps in pairs(debugger_mappings) do
      for key, val in pairs(maps) do
        -- Merge opts with the keymap options
        local key_opts = vim.tbl_extend("force", opts, val[2] or {})
        vim.keymap.set(mode, key, val[1], key_opts)
      end
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
    setup_debugger_mappings(vim.api.nvim_get_current_buf())
  end,
  __index = function(t, key)
    return rawget(original_configurations, key)
  end,
})

-- Initially update cwd in existing configurations
for lang, configs in pairs(original_configurations) do
  set_cwd_in_configurations(configs)
end

-- Autocommand to set up DAP keybindings on BufEnter (when entering a buffer)
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    setup_debugger_mappings(args.buf)
  end,
})
