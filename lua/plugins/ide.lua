return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    config = function()
      require "configs.neoconf"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require "configs.linter"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "c",
        "cpp",
        "markdown",
        "markdown_inline",
        "toml",
        "meson",
        "make",
        "hyprlang",
        "helm",
        "gitignore",
        "fish",
        "dockerfile",
        "java",
        "groovy",
        "python",
        "javascript",
        "rust",
      },
    },
    config = function(_, opts)
      local mason_bin_path = vim.fn.stdpath "data" .. "/mason/bin"
      if vim.loop.os_uname().sysname == "Windows_NT" then
        vim.env.PATH = mason_bin_path .. ";" .. vim.env.PATH
      else
        vim.env.PATH = mason_bin_path .. ":" .. vim.env.PATH
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  { import = "nvchad.blink.lazyspec" },
  {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      "saghen/blink.compat", -- nvim-cmp sources in blink
      "L3MON4D3/LuaSnip", -- snippet engine
      "micangl/cmp-vimtex", -- source of vimtex for latex
    },
    opts = require "configs.blink",
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "moll/vim-bbye",
    },
    config = function()
      require("bufferline").setup {
        options = {
          mode = "tabs",
          separator_style = "slant",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "BufferLineFill",
              text_align = "center",
              separator = false,
            },
          },
        },
      }
    end,
  },
  {
    "yorickpeterse/nvim-window",
    keys = {
      { "<leader>wj", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
    },
    config = true,
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    config = function()
      require "configs.vimtex"
    end,
    ft = {
      "tex",
      "bib",
    },
  },
  {
    "barreiroleo/ltex_extra.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },
  {
    "nvim-java/nvim-java",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "mfussenegger/nvim-dap",
    },
  },
  -- VS Tasks for VS Code task integration
  {
    "EthanJWright/vs-tasks.nvim",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("configs.vstask").setup()
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    init = function()
      require("configs.neotest-proxy").rust = "rustaceanvim.neotest"
    end,
    opts = {},
    config = function(_, opts)
      local adapter = require "rustaceanvim.neotest"(opts)
      local adapters = require("neotest.config").adapters
      table.insert(adapters, adapter)
    end,
  },
}
