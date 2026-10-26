return {
  -- Utiliser gopls fourni par Nix plutôt que Mason
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          mason = false,
        },
      },
    },
  },

  -- Éviter les installations Go automatiques via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local nix_tools = {
        "goimports",
        "gofumpt",
        "gomodifytags",
        "impl",
        "golangci-lint",
        "delve",
      }

      local excluded = {}
      for _, tool in ipairs(nix_tools) do
        excluded[tool] = true
      end

      opts.ensure_installed = vim.tbl_filter(function(tool)
        return not excluded[tool]
      end, opts.ensure_installed or {})
    end,
  },

  -- Formatage Go avec les outils installés via Nix
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
}
