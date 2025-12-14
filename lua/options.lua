require "nvchad.options"
local o = vim.o

o.relativenumber = true
o.foldenable = false -- Dont fold on File-Open
o.foldlevel = 99 -- Start with all folds open
o.textwidth = 110
o.inccommand = "nosplit"

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

-- Add Format/Enable disable per buffer
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

-- Autoclose unused empty Buffer
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("AutoCloseEmpty", { clear = true }),
  callback = function()
    -- Capture the buffer we just entered
    local current_buf = vim.api.nvim_get_current_buf()

    -- WRAPPER: Defer execution until the UI is stable (Fixes Harpoon crash)
    vim.schedule(function()
      -- Re-check validity after the delay
      if not vim.api.nvim_buf_is_valid(current_buf) then
        return
      end

      -- 1. Check special windows (NvimTree, etc)
      local current_ft = vim.api.nvim_get_option_value("filetype", { buf = current_buf })
      local current_bt = vim.api.nvim_get_option_value("buftype", { buf = current_buf })

      if current_ft == "NvimTree" or current_bt ~= "" then
        return
      end

      -- 2. Cleanup loop
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) then
          local name = vim.api.nvim_buf_get_name(buf)
          local type = vim.api.nvim_get_option_value("buftype", { buf = buf })
          local modified = vim.api.nvim_get_option_value("modified", { buf = buf })

          -- Only delete if empty, unnamed, unmodified
          if name == "" and type == "" and not modified then
            -- CRITICAL SAFETY CHECK:
            -- Is this buffer currently visible in any window?
            -- If yes, DO NOT delete it, or you'll get the "E444" crash.
            local windows = vim.fn.win_findbuf(buf)
            if #windows == 0 then
              vim.api.nvim_buf_delete(buf, { force = false })
            end
          end
        end
      end
    end)
  end,
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

local lint_timer = vim.loop.new_timer()
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
  callback = function()
    -- Stop any previously scheduled linting
    lint_timer:stop()

    -- Schedule linting to run after 2 seconds of inactivity
    lint_timer:start(
      2000,
      0,
      vim.schedule_wrap(function()
        require("lint").try_lint()
      end)
    )
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
  pattern = {
    -- match any path that ends with something like *compose*.yml or *compose*.yaml
    [".*compose.*%.ya?ml"] = "yaml.docker-compose",
  },
}
