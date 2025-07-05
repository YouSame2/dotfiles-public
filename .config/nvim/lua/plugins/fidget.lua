return {
	"j-hui/fidget.nvim",
	cond = not vim.g.vscode,
	event = "VeryLazy",
	opts = {
		notification = {
			view = {
				stack_upwards = false, -- false = oldest on bottom
			},
			window = {
				winblend = 0, -- 0 = full transparent
				border = "rounded",
			},
		},
	},
}
