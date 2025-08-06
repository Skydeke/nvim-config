-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
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

local servers = {
  clangd = {},
  ltex_plus = {
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
        checkFrequency = "save",
        completionEnabled = true,
        dictionary = (function()
          -- For dictionary, search for files in the runtime to have
          -- and include them as externals the format for them is
          -- dict/{LANG}.txt
          --
          -- Also add dict/default.txt to all of them
          local files = {}
          for _, file in ipairs(vim.api.nvim_get_runtime_file("dict/*", true)) do
            local lang = vim.fn.fnamemodify(file, ":t:r")
            local fullpath = vim.fs.normalize(file, ":p")
            files[lang] = { ":" .. fullpath }
          end

          if files.default then
            for lang, _ in pairs(files) do
              if lang ~= "default" then
                vim.list_extend(files[lang], files.default)
              end
            end
            files.default = nil
          end
          return files
        end)(),
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
            { desc = "Show LaTeX Errors" },
          },
          ["<leader>lv"] = {
            "<cmd> VimtexView <CR>",
            { desc = "Jump to position in pdf" },
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
      require("ltex_extra").setup {
        load_langs = { "en-GB", "de-DE" },
        init_check = true,
      }
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
  rust_analyzer = {
    diagnostics = {
      enable = true,
    },
    cargo = {
      buildScripts = {
        enable = true,
      },
    },
    procMacro = {
      enable = true,
    },
  },
}

require("java").setup {
  jdk = {
    auto_install = false,
  },
  notifications = {
    dap = true,
  },
  verification = {
    invalid_order = true,
    duplicate_setup_calls = true,
    invalid_mason_registry = true,
  },
}
require("lspconfig").jdtls.setup {}

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
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end
