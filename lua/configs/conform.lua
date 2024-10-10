-- Array of filetypes where autoformat is disabled by default
local disabled_autoformat_filetypes = { "yaml", "yml", "yml.docker-compose", "yaml.docker-compose" }

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    yaml = { "yamlfix" },
    tex = { "latexindent" },
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

-- Use FileType autocommand instead of BufEnter to ensure filetype is set
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local ft = vim.api.nvim_buf_get_option(args.buf, "filetype")
    if vim.tbl_contains(disabled_autoformat_filetypes, ft) then
      vim.b[args.buf].disable_autoformat = true
    end
  end,
})

return options
