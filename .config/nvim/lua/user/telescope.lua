local t_status_ok, telescope = pcall(require, "telescope")
if not t_status_ok then
	return
end

telescope.load_extension("fzf")

local b_status_ok, builtin = pcall(require, "telescope.builtin")
if not b_status_ok then
	return
end
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
