require "nvchad.options"
local o = vim.o

o.relativenumber = true
o.foldenable = false -- Dont fold on File-Open
o.foldlevel = 99 -- Start with all folds open

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    if require("nvim-treesitter.parsers").has_parser() then
      o.foldmethod = "expr"
      o.foldexpr = "nvim_treesitter#foldexpr()"
    else
      o.foldmethod = "syntax"
    end
  end,
})

-- LaTeX use VimTex folding
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "tex",
  callback = function()
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "vimtex#fold#level(v:lnum)"
  end,
})

-- Add Forrmat/Ebanle disable per buffer
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

-- Alacritty
local alacrittyAutoGroup = vim.api.nvim_create_augroup("alacritty", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = alacrittyAutoGroup,
  callback = function()
    vim.fn.system "alacritty msg --socket $ALACRITTY_SOCKET config -w $ALACRITTY_WINDOW_ID options 'window.padding.x=0' 'window.padding.y=0' 'window.dynamic_padding=false'"
  end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = alacrittyAutoGroup,
  callback = function()
    vim.fn.jobstart("alacritty msg --socket $ALACRITTY_SOCKET config -w $ALACRITTY_WINDOW_ID -r", { detach = true })
  end,
})

-- Open Quickfixes using Trouble.nvim
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "quickfix" then
      vim.schedule(function()
        -- Close the default quickfix window if it's open and open Trouble instead
        vim.cmd [[cclose]]
        vim.cmd [[Trouble qflist open]]
      end)
    end
  end,
})

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

vim.filetype.add {
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
}
vim.filetype.add {
  extension = {
    gotmpl = "gotmpl",
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
}
vim.filetype.add {
  filename = {
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose", -- handle both extensions
  },
}
