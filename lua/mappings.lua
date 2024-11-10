require "nvchad.mappings"

local rem_mappings = {
  n = {
    "<leader>n",
    "<leader>ds",
    "<leader>ma",
    "<leader>gt",
  },
}

for mode, maps in pairs(rem_mappings) do
  for _, key in ipairs(maps) do -- Use ipairs to iterate over a list
    vim.keymap.del(mode, key)
  end
end

local mappings = {
  n = {
    -- Notifications
    ["<leader>nd"] = {
      "<cmd> Noice dismiss <CR>",
      {
        desc = "Dismiss all Notifications",
      },
    },
    ["<leader>nt"] = {
      "<cmd> Noice telescope <CR>",
      {
        desc = "Display all Notifications",
      },
    },
    ["<leader>dd"] = {
      "<cmd> DiffviewOpen <CR>",
      {
        desc = "Diff Open",
      },
    },

    -- ["<leader>fm"] = {
    --   function()
    --     vim.lsp.buf.format { async = true }
    --   end,
    --   "LSP formatting",
    -- },
  },
}

for mode, maps in pairs(mappings) do
  for key, val in pairs(maps) do
    vim.keymap.set(mode, key, val[1], val[2])
  end
end
