vim.api.nvim_set_keymap("i", "<C-J>", ":copilot#Accept('\\<CR>')<CR>", {silent=true})
vim.g.copilot_no_tab_map = true
