return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
      {
        'j-hui/fidget.nvim',
        tag = 'v1.5.0',
        opts = {}
      },
    },
    opts = {
      servers = {
        lua_ls = {},
        clangd = {},
        gopls = {},
        pyright = {
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                typeCheckingMode = 'strict',
              },
            },
          },
        },
        bashls = {},
        bzl = {},
      }
    },
    config = function(_, opts)
      for server, config in pairs(opts.servers) do
        config.capabilities = require 'blink.cmp'.get_lsp_capabilities(config.capabilities)
        require 'lspconfig'[server].setup(config)
      end
    end,
  }
}
