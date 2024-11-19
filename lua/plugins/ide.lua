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
        "latex", -- requires tree-sitter-cli, auto-install fails :TSINSTALLFROMGRAMAR
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
  {
    "hrsh7th/nvim-cmp",
    opts = {
      sources = {
        { name = "nvim_lsp" },
        { name = "vimtex" },
        { name = "path" },
        { name = "buffer" },
      },
    },
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system path
      "hrsh7th/cmp-nvim-lsp", -- using LSP for source
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- using LuaSnip for source
      "micangl/cmp-vimtex", -- source of vimtex for latex
    },
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
    "Skydeke/ltex-ls.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },
  {
    "nvim-java/nvim-java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
          },
        },
      },
    },
  },
}
