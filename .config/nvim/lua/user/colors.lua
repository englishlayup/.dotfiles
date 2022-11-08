local colorschemes = {
    'tokyonight-night',
    'gruvbox',
    'tokyonight',
}

local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorschemes[math.random(#colorschemes)])
if not status_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end
