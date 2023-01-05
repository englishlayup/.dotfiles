local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
	return
end

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"css",
				"scss",
				"json",
				"yaml",
				"markdown",
				"html",
			},
			extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
		}),
		null_ls.builtins.diagnostics.flake8.with({
			filetypes = { "python" },
		}),
	},
})
