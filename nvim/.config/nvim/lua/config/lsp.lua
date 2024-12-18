local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = {
    source = 'if_many',
  },
}
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating [E]rror message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics [Q]uickfix list' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions

    -- Note: To jump back, press <C-T>
    map('gd', require 'telescope.builtin'.lsp_definitions, '[G]oto [D]efinition')
    map('gr', require 'telescope.builtin'.lsp_references, '[G]oto [R]eferences')
    map('gI', require 'telescope.builtin'.lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', require 'telescope.builtin'.lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', require 'telescope.builtin'.lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require 'telescope.builtin'.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    map('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_augroup('lsp_document_highlight', {
        clear = false,
      })
      vim.api.nvim_clear_autocmds {
        buffer = event.buf,
        group = 'lsp_document_highlight',
      }
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = 'lsp_document_highlight',
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = 'lsp_document_highlight',
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client.supports_method 'textDocument/formatting' then
      vim.api.nvim_create_augroup('lsp_document_format', {})
      vim.api.nvim_clear_autocmds { group = 'lsp_document_format', buffer = event.buf }
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = 'lsp_document_format',
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format { bufnr = event.buf, id = client.id }
        end,
      })
    end
  end,
})
