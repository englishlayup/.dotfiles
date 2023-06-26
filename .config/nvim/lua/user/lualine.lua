local status_ok, lualine = pcall(require, 'lualine')

if not status_ok then
    return
end

lualine.setup {
    sections = {
        lualine_b = {
            {
                'diagnostics',
                symbols = {
                    error = '',
                    warn = '',
                    hint = '',
                    info = '',
                },
            },
        },
    },
}
