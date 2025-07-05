return {
	"nullromo/go-up.nvim",
	cond = not vim.g.vscode,
	lazy = false,
	config = function()
		require("go-up").setup()
	end,
}
