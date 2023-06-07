local b_status_ok, telescope_builtin = pcall(require, "telescope.builtin")
if not b_status_ok then
    return
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", telescope_builtin.diagnostics, opts)

local signs = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = "",
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<leader>D", telescope_builtin.lsp_type_definitions, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", telescope_builtin.lsp_references, bufopts)
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = false,
        })
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = "lsp_document_highlight",
        })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_augroup("lsp_document_format", {})
        vim.api.nvim_clear_autocmds({ group = "lsp_document_format", buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = "lsp_document_format",
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

-- Set up lspconfig.
local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    return
end
local capabilities = cmp_nvim_lsp.default_capabilities()
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "rust_analyzer",
        "pyright",
        "dockerls",
        "lua_ls",
        "bashls",
    },
})
local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
    end,
})

-- null-ls setup
local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
    return
end

require("mason").setup()
require("mason-null-ls").setup({
    ensure_installed = {
        "stylua",
        "prettier",
        "flake8",
        "mypy",
        "black",
    },
    automatic_installation = false,
    handlers = {},
})

null_ls.setup({
    on_attach = on_attach,
    sources = {
        null_ls.builtins.formatting.prettier.with({
            extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
        }),
    },
})
