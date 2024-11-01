-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
}

M.mason = {
  cmd = true,
  pkgs = {
    "clangd", -- CPP LSP
    "clang-format", -- CPP Formatter
    "codelldb", -- Debugger
    "ltex-ls", -- Spelling LSP
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
  },
}

return M
