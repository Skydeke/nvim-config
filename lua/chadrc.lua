-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
  hl_add = { -- add highlights to use for vimtex status
    St_vtexInfo = { fg = "#61afef" },
    St_vtexIdle = { fg = "#b294bb" },
    St_vtexSuccess = { fg = "#98c379" },
    St_vtexError = { fg = "#e06c75" },
  },
  integrations = {
    "bufferline",
  },
}

M.ui = {
  statusline = {
    theme = "default",
    separator_style = "default",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "vtex", "diagnostics", "lsp", "cwd", "cursor" },
    modules = {
      vtex = function()
        if vim.b.vimtex then
          local status = vim.b.vimtex.compiler.status + 2

          local symbols_and_colors = { -- use highlights specifiged ad the top and symbol
            { " ", "%#St_vtexInfo#", "Idle" },
            { " ", "%#St_vtexInfo#", "Idle" }, -- Info (e.g., compiling)
            { " ", "%#St_vtexIdle#", "Compiling" }, -- Idle (e.g., waiting for input)
            { " ", "%#St_vtexSuccess#", "Done" }, -- Success (e.g., completed successfully)
            { " ", "%#St_vtexError#", "Error" }, -- Error (e.g., failure)
          }
          local status_symbol = symbols_and_colors[status][1]
          local color = symbols_and_colors[status][2]
          local mes = symbols_and_colors[status][3]
          return color .. status_symbol .. " " .. mes -- parse color string toghter to get specified color
        end
        return ""
      end,
    },
  },
  tabufline = {
    enabled = false, -- Disable the tab line
  },
}

M.mason = {
  cmd = true,
  pkgs = {
    "clangd", -- CPP LSP
    "clang-format", -- CPP Formatter
    "codelldb", -- Debugger
    "ltex-ls-plus", -- Spelling LSP
    "dockerfile-language-server", -- Dockerfile LSP
    "docker-compose-language-service", -- Compose LSP
    "helm-ls", -- Helm LSP
    "yamlfix", -- Yaml Formatter
    "yaml-language-server", -- Yaml LSP
    "json-lsp", -- JSON LSP
    "latexindent", -- LaTeX formatter
    "pyright", -- Python Static Type checker
    "python-lsp-server", -- Python LSP
    "debugpy", -- Python Debugger
    "black", -- Pythonf Formatter
    "html-lsp", -- HTML-LSP
    "css-lsp", -- CSS-LSP
    "typescript-language-server", -- TS/JS LSP
    "firefox-debug-adapter", -- DAP Firefox
    "prettier", -- Formatter for HTML, CSS...
    "rust-analyzer", -- Rust LSP
    "tree-sitter-cli", -- Tree-Sitter-Cli
  },
}

return M
