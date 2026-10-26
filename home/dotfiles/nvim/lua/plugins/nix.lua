return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Désactiver le serveur par défaut de l'extra Nix
        nil_ls = {
          enabled = false,
          mason = false,
        },

        -- Utiliser nixd fourni par Nix
        nixd = {
          mason = false,
          settings = {
            nixd = {
              formatting = {
                command = { "nixfmt" },
              },
            },
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "nixfmt" },
      },
    },
  },
}
