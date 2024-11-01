-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
local configs = require "nvchad.configs.lspconfig"
local mappings = {
  n = {
    -- LSP Diagnostics
    ["<leader>lgp"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      { desc = "Go to previous diagnostic" },
    },
    ["<leader>lgn"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      { desc = "Go to next diagnostic" },
    },
    ["<leader>ld"] = {
      function()
        local float_opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "single",
          source = "if_many",
          prefix = "",
        }
        vim.diagnostic.open_float(nil, float_opts)
      end,
      { desc = "Open diagnostic float" },
    },

    -- LSP Buffer Actions
    ["<leader>la"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      { desc = "Code action" },
    },
    ["<leader>lgd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      { desc = "Go to definition" },
    },
    ["<leader>lgD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      { desc = "Go to declaration" },
    },
    ["<leader>lh"] = {
      function()
        vim.lsp.buf.hover()
      end,
      { desc = "Hover info" },
    },
    ["<leader>li"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      { desc = "Go to implementation" },
    },
    ["<leader>lr"] = {
      function()
        vim.lsp.buf.rename()
      end,
      { desc = "Rename symbol" },
    },
    ["<leader>lR"] = {
      function()
        vim.lsp.buf.references()
      end,
      { desc = "Find references" },
    },
    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      { desc = "Signature help" },
    },
  },
}

local on_attach = function(client, bufnr)
  -- Mappings
  local opts = { buffer = bufnr, silent = true }
  for mode, maps in pairs(mappings) do
    for key, val in pairs(maps) do
      -- Merge opts with the keymap options
      local key_opts = vim.tbl_extend("force", opts, val[2] or {})
      vim.keymap.set(mode, key, val[1], key_opts)
    end
  end
  configs.on_attach(client, bufnr)
end

-- Snippet, autocompletion support
local capabilities = configs.capabilities
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("java").setup {
  jdk = {
    auto_install = false,
  },
  notifications = {
    -- enable 'Configuring DAP' & 'DAP configured' messages on start up
    dap = true,
  },

  -- We do multiple verifications to make sure things are in place to run this
  -- plugin
  verification = {
    -- nvim-java checks for the order of execution of following
    -- * require('java').setup()
    -- * require('lspconfig').jdtls.setup()
    -- IF they are not executed in the correct order, you will see a error
    -- notification.
    -- Set following to false to disable the notification if you know what you
    -- are doing
    invalid_order = true,
    -- nvim-java checks if the require('java').setup() is called multiple
    -- times.
    -- IF there are multiple setup calls are executed, an error will be shown
    -- Set following property value to false to disable the notification if
    -- you know what you are doing
    duplicate_setup_calls = true,
    -- nvim-java checks if nvim-java/mason-registry is added correctly to
    -- mason.nvim plugin.
    -- IF it's not registered correctly, an error will be thrown and nvim-java
    -- will stop setup
    invalid_mason_registry = true,
  },
}

local servers = {
  clangd = {},
  ltex = {
    settings = {
      ltex = {
        language = "en-GB",
        enabled = {
          "bibtex",
          "gitcommit",
          "markdown",
          "org",
          "tex",
          "restructuredtext",
          "latex",
          "context",
          "mail",
          "plaintext",
        },
      },
    },
    on_attach = function(client, bufnr)
      -- Mappings
      local ltex_mappings = {
        n = {
          -- LSP Diagnostics
          ["<leader>ll"] = {
            "<cmd> VimtexCompile <CR>",
            { desc = "Start LaTeX Compiler" },
          },
          ["<leader>lo"] = {
            "<cmd> VimtexCompileOutput <CR>",
            { desc = "Show Compiler Output" },
          },
          ["<leader>le"] = {
            "<cmd> VimtexErrors <CR>",
            { desc = "Start LaTeX Compiler" },
          },
          ["<leader>lv"] = {
            "<cmd> VimtexView <CR>",
            { desc = "Start LaTeX Compiler" },
          },
        },
      }
      local opts = { buffer = bufnr, silent = true }
      for mode, maps in pairs(ltex_mappings) do
        for key, val in pairs(maps) do
          -- Merge opts with the keymap options
          local key_opts = vim.tbl_extend("force", opts, val[2] or {})
          vim.keymap.set(mode, key, val[1], key_opts)
        end
      end
      on_attach(client, bufnr)
    end,
  },
  lua_ls = {},
  dockerls = {},
  docker_compose_language_service = {},
  helm_ls = {},
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        },
      },
    },
  },
  jsonls = {},
  jdtls = {},
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = { "W391" },
            maxLineLength = 150,
          },
        },
      },
    },
  },
  pyright = {},
  html = {},
  cssls = {},
  ts_ls = {},
}

for name, opts in pairs(servers) do
  if opts.on_init == nil then
    opts.on_init = configs.on_init
  end

  if opts.on_attach == nil then
    opts.on_attach = on_attach
  end

  if opts.capabilities == nil then
    opts.capabilities = capabilities
  end

  lspconfig[name].setup(opts)
end
