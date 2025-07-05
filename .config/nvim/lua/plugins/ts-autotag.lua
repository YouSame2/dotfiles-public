return {
	"windwp/nvim-ts-autotag",
	cond = not vim.g.vscode,
	ft = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"html",
	},
	opts = {},
}
