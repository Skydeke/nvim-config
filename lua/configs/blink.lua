return {
  enabled = function()
    return not vim.list_contains({ "DressingInput", "NvimTree" }, vim.bo.filetype)
      and vim.bo.buftype ~= "prompt"
      and vim.b.completion ~= false
  end,
  sources = {
    default = { "vimtex", "lsp", "path", "snippets", "buffer" },
    providers = {
      vimtex = {
        name = "vimtex",
        module = "blink.compat.source",
        score_offset = 300, -- make VimTeX completions appear at the very top
      },
    },
  },
  snippets = { preset = "luasnip" },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
      update_delay_ms = 50,
      treesitter_highlighting = true,
      window = { border = "rounded" },
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
    menu = {
      border = "rounded",
    },
  },
  keymap = {
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = {
      "accept",
      "snippet_forward",
      "fallback",
    },
    ["<S-Tab>"] = {
      "snippet_backward",
      function(cmp)
        return cmp.select_prev()
      end,
      "fallback",
    },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-up>"] = { "scroll_documentation_up", "fallback" },
    ["<C-down>"] = { "scroll_documentation_down", "fallback" },
  },
  -- Experimental signature help support
  signature = {
    enabled = true,
    window = { border = "rounded" },
  },
}
