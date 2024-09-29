-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onenord",
}

M.mason = {
  cmd = true,
  pkgs = {
    "clangd", -- CPP LSP
    "clang-format", -- CPP Formatter
    "codelldb", -- Debugger
    "ltex-ls", -- Spelling LSP
  },
}

return M
