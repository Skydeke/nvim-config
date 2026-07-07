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

    ["<leader>ix"] = {
      "<cmd>Trouble diagnostics toggle<cr>",
      {
        desc = "Diagnostics (Trouble)",
      },
    },
    ["<leader>iX"] = {
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      {
        desc = "Buffer Diagnostics (Trouble)",
      },
    },
    ["<leader>is"] = {
      "<cmd>Trouble symbols toggle focus=false<cr>",
      {
        desc = "Symbols (Trouble)",
      },
    },
    ["<leader>il"] = {
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      {
        desc = "LSP Definitions / References / ... (Trouble)",
      },
    },
    ["<leader>iL"] = {
      "<cmd>Trouble loclist toggle<cr>",
      {
        desc = "Location List (Trouble)",
      },
    },
    ["<leader>iQ"] = {
      "<cmd>Trouble qflist toggle<cr>",
      {
        desc = "Quickfix List (Trouble)",
      },
    },

    -- VS Tasks
    ["<leader>ta"] = {
      "<cmd>lua require('configs.vstask').show_tasks()<CR>",
      {
        desc = "Show tasks",
      },
    },
    ["<leader>ti"] = {
      "<cmd>lua require('configs.vstask').show_inputs()<CR>",
      {
        desc = "Task inputs",
      },
    },
    ["<leader>tj"] = {
      "<cmd>lua require('configs.vstask').show_jobs()<CR>",
      {
        desc = "View jobs",
      },
    },
    ["<leader>tr"] = {
      "<cmd>lua require('telescope').extensions.vstask.run()<CR>",
      {
        desc = "Run command",
      },
    },

    -- Harpoon
    ["<leader>a"] = {
      function()
        require("harpoon"):list():add()
      end,
      {
        desc = "Add file to harpoon",
      },
    },
    ["<leader>e"] = {
      function()
        require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
      end,
      {
        desc = "Toggle harpoon quick menu",
      },
    },
    ["<leader>1"] = {
      function()
        require("harpoon"):list():select(1)
      end,
      {
        desc = "Go to harpoon file 1",
      },
    },
    ["<leader>2"] = {
      function()
        require("harpoon"):list():select(2)
      end,
      {
        desc = "Go to harpoon file 2",
      },
    },
    ["<leader>3"] = {
      function()
        require("harpoon"):list():select(3)
      end,
      {
        desc = "Go to harpoon file 3",
      },
    },
    ["<leader>4"] = {
      function()
        require("harpoon"):list():select(4)
      end,
      {
        desc = "Go to harpoon file 4",
      },
    },
    ["<leader>x"] = {
      "<cmd>Bdelete<CR>",
      {
        desc = "Close current buffer",
      },
    },
    ["<leader>j"] = {
      "<cmd>bnext<CR>",
      {
        desc = "Next buffer",
      },
    },
    ["<leader>k"] = {
      "<cmd>bprevious<CR>",
      {
        desc = "Previous buffer",
      },
    },

    -- NvimTree
    ["<leader>t"] = {
      "<cmd>NvimTreeToggle<CR>",
      {
        desc = "Toggle nvimtree",
      },
    },

    -- Comment mapping for normal mode
    ["<leader>/"] = {
      "gcc",
      {
        desc = "Toggle comment",
        remap = true,
        silent = true,
      },
    },

    -- ["<leader>fm"] = {
    --   function()
    --     vim.lsp.buf.format { async = true }
    --   end,
    --   "LSP formatting",
    -- },
  },
  v = {
    ["<leader>/"] = {
      "gc",
      {
        desc = "Toggle comment",
        remap = true,
        silent = true,
      },
    },
  },
}

for mode, maps in pairs(mappings) do
  for key, val in pairs(maps) do
    vim.keymap.set(mode, key, val[1], val[2])
  end
end
