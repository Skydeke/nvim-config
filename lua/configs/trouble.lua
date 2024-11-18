local opts = {
  auto_close = true, -- auto close when there are no items
}

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

vim.notify("Quickfix list opened in Trouble.", vim.log.levels.INFO)
return opts
