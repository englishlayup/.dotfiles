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
vim.o.completeopt = 'menuone,noselect'

-- Search opts
vim.o.showmatch = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.showcmd = true
vim.o.errorbells = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.o.undofile = true
vim.o.termguicolors = true
vim.o.mouse = ''

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Return to last edit position when opening files (You want this!)
vim.cmd [[autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]
