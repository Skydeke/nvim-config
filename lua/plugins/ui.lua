return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "stevearc/dressing.nvim",
    -- Installed because https://github.com/folke/noice.nvim/issues/938
    event = "VeryLazy",
    opts = {
      select = {
        backend = { "nui", "telescope", "fzf_lua", "fzf", "builtin" },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    dependencies = {},
    config = function()
      require "configs.diffview"
    end,
  },
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit", "NeogitCommit", "NeogitLogCurrent", "NeogitResetState" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require "configs.neogit"
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = function()
      require "configs.trouble"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("configs.harpoon").setup()
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    lazy = false,
    config = function()
      require("tiny-inline-diagnostic").setup {
        options = {
          multilines = { enabled = true },
          show_source = { enabled = true },
        },
      }
      -- Disable global virtual text and virtual lines
      local disable_virtual = function()
        vim.diagnostic.config { virtual_text = false, virtual_lines = false }
        for _, ns in pairs(vim.diagnostic.get_namespaces()) do
          vim.diagnostic.config({ virtual_text = false, virtual_lines = false }, ns)
        end
      end

      -- Run immediately for existing namespaces
      disable_virtual()

      -- Ensure any new LSP client also respects this
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.diagnostic.config { virtual_text = false }
        end,
      })
    end,
  },
}
