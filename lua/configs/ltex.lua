local M = {}

-- All languages supported by LTeX
M.languages = {
  "ast-ES",
  "be-BY",
  "br-FR",
  "ca-ES",
  "ca-ES-valencia",
  "da-DK",
  "de-AT",
  "de-CH",
  "de-DE",
  "de-DE-x-simple-language",
  "el-GR",
  "en-AU",
  "en-CA",
  "en-GB",
  "en-NZ",
  "en-US",
  "en-ZA",
  "es-AR",
  "ga-IE",
  "gl-ES",
  "ja-JP",
  "km-KH",
  "nl-BE",
  "pl-PL",
  "pt-AO",
  "pt-BR",
  "pt-MZ",
  "pt-PT",
  "ro-RO",
  "ru-RU",
  "sk-SK",
  "sl-SI",
  "ta-IN",
  "tl-PH",
  "uk-UA",
  "zh-CN",
}

--- Set the LTeX language for the current buffer's LSP client and notify the server.
---@param lang string A BCP 47 language tag, e.g. "de-DE"
function M.set_language(lang)
  -- bufnr=0 is NOT "current buffer" in get_clients; use the real bufnr.
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { name = "ltex_plus", bufnr = bufnr }

  -- Fall back to any attached ltex_plus client (e.g. when called from a non-ltex buffer)
  if #clients == 0 then
    clients = vim.lsp.get_clients { name = "ltex_plus" }
  end

  if #clients == 0 then
    vim.notify("LTeX LSP client not running", vim.log.levels.WARN)
    return
  end

  for _, client in ipairs(clients) do
    -- Mutate the nested table in-place so nvim's workspace/configuration pull handler
    -- returns the updated value when ltex-ls re-requests its config after the notify.
    -- (tbl_deep_extend would replace the table reference, breaking the pull handler.)
    if client.config.settings and client.config.settings.ltex then
      client.config.settings.ltex.language = lang
    end
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end

  vim.notify("LTeX language set to: " .. lang, vim.log.levels.INFO)
end

--- Register the :LtexSetLang command with completion backed by blink.cmp-compatible cmdline.
--- Native nvim completion (used by blink.cmp's cmdline source) picks up the custom_complete.
function M.register_command()
  vim.api.nvim_create_user_command("LtexSetLang", function(opts)
    local lang = vim.trim(opts.args)
    if lang == "" then
      vim.notify("Usage: LtexSetLang <language>  e.g. LtexSetLang de-DE", vim.log.levels.WARN)
      return
    end
    M.set_language(lang)
  end, {
    nargs = 1,
    desc = "Set LTeX spell-check language (e.g. de-DE, en-GB)",
    complete = function(arglead)
      if arglead == "" then
        return M.languages
      end
      return vim.tbl_filter(function(lang)
        return lang:lower():find(arglead:lower(), 1, true) ~= nil
      end, M.languages)
    end,
  })
end

return M
