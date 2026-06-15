local config = require "nvchad.configs.nvimtree"
local api = require "nvim-tree.api"

config.view.adaptive_size = true
config.view.width = {
  min = 40,
  max = -1,
}

-- Close nvim-tree automatically when the cursor moves away
local function close_nvim_tree_on_cursor_move()
  local current_win = vim.api.nvim_get_current_win()
  local nvim_tree_win = nil

  -- Check for Nvim-tree window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if bufname:match "NvimTree_" then
      nvim_tree_win = win
      break
    end
  end

  -- If the cursor is not in the Nvim-tree window, close it
  if nvim_tree_win and current_win ~= nvim_tree_win then
    api.tree.close()
  end
end

-- Auto commands
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = close_nvim_tree_on_cursor_move,
  nested = true,
})

return config
