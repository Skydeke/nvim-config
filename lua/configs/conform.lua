local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    yaml = { "yamlfix" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = false }
  end,
}

return options
