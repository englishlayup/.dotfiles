local o = vim.opt
o.tabstop=4
o.softtabstop=4
o.expandtab=true
o.shiftwidth=4
o.autoindent=true
o.relativenumber=true
o.number=true
o.wildmode={"list", "longest"}
o.signcolumn="auto"
o.scrolloff=8
o.cursorline=true
o.ignorecase=true
o.smartcase=true
o.showmatch=true
o.hlsearch=false
o.incsearch=true
o.showcmd=true
o.updatetime=50
o.errorbells=false
o.swapfile = false
o.backup = false
o.undodir = os.getenv('HOME') .. '/.vim/undodir'
o.undofile = true
o.termguicolors=true
o.mouse=""
-- FINDING FILES:

-- Search down into subfolders
-- Provides tab-completion for all file-related tasks
o.path:append('**')

-- Display all matching files when we tab complete
o.wildmenu=true
o.wildignore={
    '**/node_modules/**',
    '.hg,.git,.svn',                       -- Version control 
    '*.jpg,*.bmp,*.gif,*.png,*.jpeg',      -- binary images
    '*.o,*.obj,*.exe,*.dll,*.manifest',    -- compiled object files
    '*.pyc',                               -- Python byte code
    }
-- NOW WE CAN:
-- - Hit tab to :find by partial match
-- - Use * to make it fuzzy

-- THINGS TO CONSIDER:
-- - :b lets you autocomplete any open buffer
