local M = {}

M.setup = function()
  local harpoon = require("harpoon")

  -- Setup harpoon
  harpoon:setup({
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
      key = function()
        return vim.loop.cwd()
      end,
    },
  })

  -- Highlight current file in harpoon buffer list
  local harpoon_extensions = require("harpoon.extensions")
  harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
end

return M 