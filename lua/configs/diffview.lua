local diffview = require "diffview"

-- Listen for NeogitMerge event
vim.api.nvim_create_autocmd("User", {
  pattern = "NeogitMerge",
  callback = function(event)
    if event.data.status == "conflict" then
      vim.notify("Merge conflict detected. Attempting to open Diffview...", vim.log.levels.WARN)

      if pcall(vim.cmd, "DiffviewOpen") then
      else
        vim.notify("Failed to open Diffview.", vim.log.levels.ERROR)
      end
    end
  end,
})

-- Listen for NeogitRebase event
vim.api.nvim_create_autocmd("User", {
  pattern = "NeogitRebase",
  callback = function(event)
    if event.data.status == "conflict" then
      vim.notify("Rebase conflict detected. Attempting to open Diffview...", vim.log.levels.WARN)

      if pcall(vim.cmd, "DiffviewOpen") then
      else
        vim.notify("Failed to open Diffview.", vim.log.levels.ERROR)
      end
    end
  end,
})

diffview.setup {
  enhanced_diff_hl = true,
  default_args = {
    DiffviewOpen = { "--imply-local" },
  },
  view = {
    -- Configure the layout and behavior of different types of views.
    -- Available layouts:
    --  'diff1_plain'
    --    |'diff2_horizontal'
    --    |'diff2_vertical'
    --    |'diff3_horizontal'
    --    |'diff3_vertical'
    --    |'diff3_mixed'
    --    |'diff4_mixed'
    -- For more info, see |diffview-config-view.x.layout|.
    default = {
      -- Config for changed files, and staged files in diff views.
      layout = "diff2_horizontal",
      disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
      winbar_info = true, -- See |diffview-config-view.x.winbar_info|
    },
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_horizontal",
      disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
      winbar_info = true, -- See |diffview-config-view.x.winbar_info|
    },
    file_history = {
      -- Config for changed files in file history views.
      layout = "diff2_horizontal",
      disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
      winbar_info = true, -- See |diffview-config-view.x.winbar_info|
    },
  },
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      {
        "n",
        "<leader>dc",
        function()
          vim.cmd "DiffviewClose"
        end,
        { desc = "Close Diffview" },
      },
    },
    file_panel = {
      {
        "n",
        "<leader>dc",
        function()
          vim.cmd "DiffviewClose"
        end,
        { desc = "Close Diffview" },
      },
    },
  },
}
