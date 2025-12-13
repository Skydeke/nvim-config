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
        "latex", -- requires tree-sitter-cli, auto-install fails :TSINSTALLFROMGRAMAR
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
    opts = {
      sources = {
        default = { "vimtex", "lsp", "path", "snippets", "buffer" },
        providers = {
          vimtex = {
            name = "vimtex",
            module = "blink.compat.source",
            score_offset = 300, -- make VimTeX completions appear at the very top
          },
        },
      },
      snippets = { preset = "luasnip" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = { border = "rounded" },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          border = "rounded",
        },
      },
      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          "accept",
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = {
          "snippet_backward",
          function(cmp)
            return cmp.select_prev()
          end,
          "fallback",
        },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-up>"] = { "scroll_documentation_up", "fallback" },
        ["<C-down>"] = { "scroll_documentation_down", "fallback" },
      },
      -- Experimental signature help support
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
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
  {
    "famiu/bufdelete.nvim",
    lazy = false,
  },
}
