return {
  {
    "olimorris/codecompanion.nvim",
    branch = "feat/add-ollama-tools",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup {
        -- Chat buffer configuration
        chat = {
          border = "rounded",
          width = 80,
          height = 20,
        },
        -- Enable inline assistant
        inline = {
          enabled = true,
          border = "rounded",
        },
        -- Enable tools and workflows
        tools = {
          enabled = true,
        },
        -- Logging configuration
        log_level = "INFO", -- DEBUG, INFO, WARN, ERROR
        adapters = {
          opts = {
            allow_insecure = true,
          },
          -- Example configuration for OpenAI (you'll need to add your API key)
          -- openai = {
          --   api_key = vim.env.OPENAI_API_KEY,
          --   model = "gpt-4",
          -- },
          -- Example configuration for Anthropic Claude
          -- anthropic = {
          --   api_key = vim.env.ANTHROPIC_API_KEY,
          --   model = "claude-3-sonnet-20240229",
          -- },
          -- Example configuration for Ollama (local models)
          -- ollama = {
          --   base_url = "http://localhost:11434",
          --   model = "codellama",
          -- },
          -- Remote Ollama adapter for https://ollama.doubleslash.org
          remote_ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "remote_ollama",
              env = {
                url = "http://ollama.doubleslash.org:11434",
                -- api_key = vim.env.DS_OLLAMA_API_KEY,
              },
              -- headers = {
              --   ["Content-Type"] = "application/json",
              --   ["Authorization"] = "Bearer ${api_key}",
              -- },
              parameters = {
                sync = true,
              },
              schema = {
                model = {
                  default = "llama3.1",
                },
                num_ctx = {
                  default = 16384,
                },
                num_predict = {
                  default = -1,
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = "remote_ollama",
          },
          inline = {
            adapter = "remote_ollama",
          },
          agent = {
            adapter = "remote_ollama",
          },
        },
      }
    end,
    keys = {
      -- Default keymaps for CodeCompanion
      { "<leader>ci", "<cmd>CodeCompanion<CR>", desc = "Open CodeCompanion Inline" },
      { "<leader>cc", "<cmd>CodeCompanionChat<CR>", desc = "Open CodeCompanion Chat" },
      { "<leader>ca", "<cmd>CodeCompanionActions<CR>", desc = "Open CodeCompanion Actions" },
      { "<leader>ct", "<cmd>CodeCompanionCmd<CR>", desc = "Open Tools" },
    },
  },
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require "mini.diff"
      diff.setup {
        -- Disabled by default
        source = diff.gen_source.none(),
      }
    end,
  },
}

