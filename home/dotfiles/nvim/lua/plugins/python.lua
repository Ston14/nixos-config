return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          mason = false,
        },
        ruff = {
          mason = false,
        },
      },
    },
  },
}
