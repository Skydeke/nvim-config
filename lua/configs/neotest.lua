local testing_mappings = {
  n = {
    ["<leader>tta"] = {
      function()
        _ = require("configs.neotest-proxy")[vim.bo.filetype]
        require("neotest").run.run(vim.fn.getcwd(), true)
        require("neotest").summary.open()
        require("neotest").output_panel.open()
      end,
      { desc = "Run all Tests" },
    },
    ["<leader>ttf"] = {
      function()
        _ = require("configs.neotest-proxy")[vim.bo.filetype]
        require("neotest").run.run(vim.fn.expand "%")
        require("neotest").output_panel.open()
      end,
      { desc = "Run open Class" },
    },
    ["<leader>ttm"] = {
      function()
        _ = require("configs.neotest-proxy")[vim.bo.filetype]
        require("neotest").run.run()
        require("neotest").output_panel.open()
      end,
      { desc = "Run Method" },
    },
    ["<leader>tts"] = {
      function()
        _ = require("configs.neotest-proxy")[vim.bo.filetype]
        require("neotest").run.stop()
        require("neotest").summary.close()
        require("neotest").output_panel.close()
      end,
      { desc = "Stop Tests" },
    },
  },
}

local opts = { buffer = bufnr, silent = true }
for mode, maps in pairs(testing_mappings) do
  for key, val in pairs(maps) do
    local key_opts = vim.tbl_extend("force", opts, val[2] or {})
    vim.keymap.set(mode, key, val[1], key_opts)
  end
end

require("neotest").setup {
  adapters = {
    -- no adapters registered on initial setup
  },
  quickfix = {
    open = function()
      require("trouble").open { mode = "quickfix", focus = false }
    end,
  },
}
