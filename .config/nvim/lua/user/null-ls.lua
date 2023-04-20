local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end
require("mason").setup()
require("mason-null-ls").setup({
    ensure_installed = {
        "stylua",
        "prettier",
        "markdownlint",
        "flake8",
        "mypy",
        "black",
    },
    automatic_installation = false,
    handlers = {},
})
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
        }),
    },
})
