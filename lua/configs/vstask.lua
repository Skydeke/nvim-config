local M = {}

M.setup = function()
  require("telescope").load_extension("vstask")
  require("vstask").setup({
    cache_json_conf = true,
    cache_strategy = "last",
    config_dir = ".vscode",
    support_code_workspace = true,
    telescope_keys = {
      vertical = '<C-v>',
      split = '<C-p>',
      tab = '<C-t>',
      current = '<CR>',
      background = '<C-b>',
      watch_job = '<C-w>',
      kill_job = '<C-d>',
      run = '<C-r>',
    },
    autodetect = {
      npm = "on"
    },
    terminal = 'nvim',
    term_opts = {
      vertical = { direction = "vertical", size = "80" },
      horizontal = { direction = "horizontal", size = "10" },
      current = { direction = "float" },
      tab = { direction = 'tab' }
    },
    json_parser = vim.json.decode,
    default_tasks = {
      { label = "npm install", type = "shell", command = "npm i", filetypes = { "typescript", "javascript" } },
      { label = "pip install", type = "shell", command = "pip install -r requirements.txt", filetypes = { "python" } },
      { label = "cargo build", type = "shell", command = "cargo build", filetypes = { "rust" } },
      { label = "make", type = "shell", command = "make", filetypes = { "c", "cpp", "make" } },
    },
    ignore_input_default = false
  })
end

-- Better display functions
M.show_tasks = function()
  require('telescope').extensions.vstask.tasks(require('telescope.themes').get_dropdown({
    prompt_title = "VS Code Tasks",
    results_title = "Available Tasks",
    layout_config = { width = 0.8, height = 0.8 },
    border = true,
  }))
end

M.show_inputs = function()
  require('telescope').extensions.vstask.inputs(require('telescope.themes').get_dropdown({
    prompt_title = "Task Inputs",
    layout_config = { width = 0.8, height = 0.6 },
    border = true,
  }))
end

M.show_jobs = function()
  require('telescope').extensions.vstask.jobs(require('telescope.themes').get_dropdown({
    prompt_title = "Background Jobs",
    layout_config = { width = 0.9, height = 0.8 },
    border = true,
  }))
end

return M 