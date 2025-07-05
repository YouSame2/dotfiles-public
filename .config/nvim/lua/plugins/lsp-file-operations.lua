-- NOTE: needs to load after neo-tree so im just using InsertEnter event
return {
	"antosha417/nvim-lsp-file-operations",
	cond = not vim.g.vscode,
	event = "InsertEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-neo-tree/neo-tree.nvim",
	},
	config = function()
		require("lsp-file-operations").setup()
	end,
}
