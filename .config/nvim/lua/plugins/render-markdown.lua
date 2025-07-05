return {
	"MeanderingProgrammer/render-markdown.nvim",
	cond = not vim.g.vscode,
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	-- event = "VeryLazy",
	ft = { "markdown", "Avante", "codecompanion" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		heading = {
			icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
		},
		file_types = { "markdown", "Avante", "codecompanion" },
		code = {
			left_margin = 0.05,
			left_pad = 2,
			width = "block",
		},
		overrides = {
			buftype = {
				nofile = {
					-- enabled = false, -- disable plugin in lsp hover
					code = {
						left_margin = 0,
						width = "full",
					},
				},
			},
			filetype = {
				Avante = {
					enabled = true,
				},
				codecompanion = {
					enabled = true,
				},
			},
		},
	},
	config = function(_, opts)
		vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "NvimDarkGray2" })

		require("render-markdown").setup(opts)
	end,
}
