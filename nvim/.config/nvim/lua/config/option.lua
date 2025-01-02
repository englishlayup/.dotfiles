-- KEYMAPS & OPTIONS

-- Remap space as leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Indent opts
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.o.breakindent = true

vim.o.relativenumber = true
vim.wo.number = true
vim.o.signcolumn = 'auto'
vim.o.scrolloff = 8
vim.o.cursorline = true

-- Search opts
vim.o.showmatch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.o.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Preview substitutions live, as you type
vim.opt.inccommand = 'split'

vim.o.showcmd = false
vim.o.errorbells = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.o.undofile = true
vim.o.termguicolors = true
vim.o.mouse = ''

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Return to last edit position when opening files
vim.cmd [[autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]

vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- tmux-sessionizer
vim.keymap.set('n', '<C-f>', ':silent !tmux neww tmux-sessionizer<CR>', { silent = true })

-- Keybinds to make split navigation easier.
--  Use ALT+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<A-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('t', '<A-h>', '<C-\\><C-N><C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<A-l>', '<C-\\><C-N><C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<A-j>', '<C-\\><C-N><C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<A-k>', '<C-\\><C-N><C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-w>+', '<cmd>resize +5<CR>', { desc = 'Increase current window height by 5' })
vim.keymap.set('n', '<C-w>-', '<cmd>resize -5<CR>', { desc = 'Decrease current window height by 5' })
vim.keymap.set('n', '<C-w>>', '<cmd>vertical resize +5<CR>', { desc = 'Increase current window width by 5' })
vim.keymap.set('n', '<C-w><', '<cmd>vertical resize -5<CR>', { desc = 'Decrease current window width by 5' })

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

-- Terminal

-- Start terminal in insert mode
vim.cmd [[autocmd TermOpen * startinsert]]

vim.api.nvim_create_user_command('PythonRepl', function()
  vim.cmd.term 'python3'
end, {
  desc = 'Launch a Python repl',
})

vim.keymap.set('n', '<leader>py', '<cmd>PythonRepl<CR>', { desc = 'Start [Py]thon REPL' })

vim.keymap.set('n', '<leader>t', function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd 'J'
    vim.api.nvim_win_set_height(0, 15)
  end,
  { desc = 'Start [T]erminal' })
