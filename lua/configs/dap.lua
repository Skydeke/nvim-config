local dap = require "dap"

local config_enhancements_fts = { "java" } -- Automatically set cwd to target if it was unset for listed langs
local target_dir = "target"

dap.adapters.cpp = {
  name = "codelldb server",
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}

dap.adapters.firefox = {
  type = "executable",
  executable = {
    command = vim.fn.stdpath "data" .. "/mason/bin/firefox-debug-adapter",
  },
}

-- Java-Adapter is loaded by nvim-java require(java).setup

dap.configurations.html = {
  {
    type = "firefox",
    name = "FF: Launch",
    request = "launch",
    reAttach = "true",
    url = "http://localhost/index.html",
    pathMappings = {
      {
        url = "http://localhost",
        path = "${workspaceFolder}",
      },
    },
    log = {
      fileName = "${workspaceFolder}/log.txt",
      fileLevel = {
        default = "Debug",
      },
    },
    firefoxExecutable = vim.fn.stdpath "data" .. "/mason/bin/firefox",
    firefoxArgs = { "-private", "-purgecaches" },
  },
  {
    type = "firefox",
    name = "FF: Localhost webserver",
    request = "launch",
    reAttach = "true",
    url = "http://localhost/index.html",
    webRoot = "${workspaceFolder}",
    log = {
      fileName = "${workspaceFolder}/log.txt",
      fileLevel = {
        default = "Debug",
      },
    },
    firefoxExecutable = vim.fn.stdpath "data" .. "/mason/bin/firefox",
    firefoxArgs = { "-private", "-purgecaches" },
  },
  {
    name = "FF: Attach to localhost",
    type = "firefox",
    request = "attach",
    url = "http://127.0.0.1/",
    firefoxExecutable = vim.fn.stdpath "data" .. "/mason/bin/firefox",
    firefoxArgs = { "-private", "-purgecaches" },
  },
}

-- Define your keybindings
local debugger_mappings = {
  n = {
    -- LSP Diagnostics
    ["<leader>do"] = {
      function()
        require("dapui").open()
        vim.cmd "NvimTreeClose"
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

local function read_json_file(filepath)
  local uv = vim.loop
  local fd = uv.fs_open(filepath, "r", 438) -- 438 is the default file permission
  if not fd then
    vim.notify("Could not open file: " .. filepath, vim.log.levels.ERROR)
    return nil
  end

  local stat = uv.fs_fstat(fd)
  if not stat then
    vim.notify("Could not stat file: " .. filepath, vim.log.levels.ERROR)
    uv.fs_close(fd)
    return nil
  end

  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)

  if not data then
    vim.notify("Could not read file: " .. filepath, vim.log.levels.ERROR)
    return nil
  end

  local ok, parsed = pcall(vim.json.decode, data)
  if not ok then
    vim.notify("Invalid JSON in file: " .. filepath, vim.log.levels.ERROR)
    return nil
  end

  return parsed
end

local function run_pre_launch_task(preLaunchTask)
  if not preLaunchTask then
    return
  end

  local tasks = read_json_file(vim.fn.getcwd() .. "/.vscode/tasks.json")
  if not tasks or not tasks.tasks then
    return
  end

  for _, task in ipairs(tasks.tasks) do
    if task.label == preLaunchTask then
      local command = task.command
      if command then
        vim.notify("Running preLaunchTask: " .. preLaunchTask)
        vim.fn.system(command)
      else
        vim.notify("No command found for preLaunchTask: " .. preLaunchTask, vim.log.levels.WARN)
      end
      return
    end
  end
end

local function get_target_directory_path()
  return vim.fn.getcwd() .. "/" .. target_dir
end

local function ensure_target_directory()
  local target_path = get_target_directory_path()
  if vim.fn.isdirectory(target_path) == 0 then
    vim.fn.mkdir(target_path, "p")
  end
  return target_path
end

-- Function to update `cwd` in configurations only if it's in specified filetypes
local function set_cwd_in_configurations(configs)
  for _, config in ipairs(configs) do
    if not config.cwd then
      config.cwd = get_target_directory_path() -- Set `cwd` to target path without creating it yet
    end
  end
end

local function setup_debugger_mappings(bufnr)
  local dap = require "dap"

  -- Check if the current buffer has a DAP configuration
  local configurations = dap.configurations[vim.bo.filetype]
  if configurations and #configurations > 0 then
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
    if vim.tbl_contains(config_enhancements_fts, lang) then
      set_cwd_in_configurations(configs)
    end
    rawset(t, lang, configs)
    setup_debugger_mappings(vim.api.nvim_get_current_buf())
  end,
  __index = function(t, key)
    return rawget(original_configurations, key)
  end,
})

-- Initially update cwd only for specified filetypes
for lang, configs in pairs(original_configurations) do
  if vim.tbl_contains(config_enhancements_fts, lang) then
    set_cwd_in_configurations(configs)
  end
end

-- Ensure target directory is created when launching a DAP session if necessary
local original_dap_run = dap.run
dap.run = function(config, ...)
  if config.preLaunchTask then
    run_pre_launch_task(config.preLaunchTask)
  end
  if config.cwd == get_target_directory_path() then
    ensure_target_directory()
  end
  original_dap_run(config, ...)
end

-- Autocommand to set up DAP keybindings on BufEnter for relevant filetypes
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    setup_debugger_mappings(args.buf)
  end,
})
