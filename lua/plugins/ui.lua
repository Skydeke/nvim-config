return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "stevearc/dressing.nvim",
    -- Installed because https://github.com/folke/noice.nvim/issues/938
    event = "VeryLazy",
    opts = {
      select = {
        backend = { "nui", "telescope", "fzf_lua", "fzf", "builtin" },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    dependencies = {},
    config = function()
      require "configs.diffview"
    end,
  },
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit", "NeogitCommit", "NeogitLogCurrent", "NeogitResetState" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require "configs.neogit"
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = function()
      require "configs.trouble"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("configs.harpoon").setup()
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    lazy = false,
    config = function()
      require("tiny-inline-diagnostic").setup {
        options = {
          multilines = { enabled = true },
          show_source = { enabled = true },
        },
      }
      -- Disable global virtual text and virtual lines
      local disable_virtual = function()
        vim.diagnostic.config { virtual_text = false, virtual_lines = false }
        for _, ns in pairs(vim.diagnostic.get_namespaces()) do
          vim.diagnostic.config({ virtual_text = false, virtual_lines = false }, ns)
        end
      end

      -- Run immediately for existing namespaces
      disable_virtual()

      -- Ensure any new LSP client also respects this
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.diagnostic.config { virtual_text = false }
        end,
      })
    end,
  },
  {
    "mawkler/modicator.nvim",
    event = "BufEnter",
    opts = {
      show_warnings = true,
      highlights = {
        defaults = {
          bold = true,
          italic = false,
        },
        use_cursorline_background = false,
      },
    },
    config = function(_, opts)
      local function link_modicator_colors()
        local function set_fg_from_bg(mod_name, st_name)
          local _, hl = pcall(vim.api.nvim_get_hl, 0, { name = st_name })
          local fg = hl.bg and string.format("#%06x", hl.bg) or "NONE"

          vim.api.nvim_set_hl(0, mod_name, {
            fg = fg,
            bg = "NONE",
            bold = true,
          })
        end

        local mapping = {
          { "NormalMode", "St_NormalMode" },
          { "InsertMode", "St_InsertMode" },
          { "VisualMode", "St_VisualMode" },
          { "ReplaceMode", "St_ReplaceMode" },
          { "CommandMode", "St_CommandMode" },
          { "SelectMode", "St_SelectMode" },
          { "TerminalMode", "St_TerminalMode" },
          { "TerminalNormalMode", "St_NTerminalMode" },
        }

        for _, pair in ipairs(mapping) do
          set_fg_from_bg(pair[1], pair[2])
        end
      end

      -- Apply after modicator setup
      require("modicator").setup(opts)

      -- Initial apply
      link_modicator_colors()

      -- Reapply on theme reload
      vim.api.nvim_create_autocmd("User", {
        pattern = "NvThemeReload",
        callback = link_modicator_colors,
      })
    end,
  },
  {
    "yorickpeterse/nvim-window",
    keys = {
      { "<leader>wj", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
    },
    config = true,
  },
}
