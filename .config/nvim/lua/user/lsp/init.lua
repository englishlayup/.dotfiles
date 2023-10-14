local signs = {
    Error = '',
    Warn = '',
    Hint = '',
    Info = '',
}

for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config {
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    float = {
        source = 'always',
    },
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false,
        })
        vim.api.nvim_clear_autocmds {
            buffer = bufnr,
            group = 'lsp_document_highlight',
        }
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    if client.supports_method 'textDocument/formatting' then
        vim.api.nvim_create_augroup('lsp_document_format', {})
        vim.api.nvim_clear_autocmds { group = 'lsp_document_format', buffer = bufnr }
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = 'lsp_document_format',
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
            end,
        })
    end
end

-- document existing key chains
require('which-key').register {
    ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
    ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
    ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

-- Set up lspconfig.
local status_cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_cmp_ok then
    return
end
local capabilities = cmp_nvim_lsp.default_capabilities()
require('mason-lspconfig').setup {
    ensure_installed = {
        'pyright',
        'dockerls',
        'lua_ls',
        'bashls',
    },
}
local lspconfig = require 'lspconfig'
require('mason-lspconfig').setup_handlers {
    function(server_name)
        lspconfig[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end,
    ['lua_ls'] = function()
        lspconfig.lua_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                            [vim.fn.stdpath 'config' .. '/lua'] = true,
                        },
                    },
                },
            },
        }
    end,
}

-- null-ls setup
local null_ls_ok, null_ls = pcall(require, 'null-ls')

if not null_ls_ok then
    return
end

null_ls.setup {
    on_attach = on_attach,
    sources = {
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.stylua,
    },
}
