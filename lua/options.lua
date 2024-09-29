require "nvchad.options"

-- add yours here!

local o = vim.o

o.relativenumber = true

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
