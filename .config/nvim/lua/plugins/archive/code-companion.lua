return {
	"olimorris/codecompanion.nvim",
	lazy = false,
	dependencies = {
		"j-hui/fidget.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			-- log_level = "DEBUG",
			display = {
				chat = {
					-- show_settings = true,
					auto_scroll = false,
					show_header_separator = true,
				},
			},
			strategies = {
				chat = {
					adapter = "gemini",
				},
				inline = {
					adapter = "gemini",
				},
				cmd = {
					adapter = "gemini",
				},
			},
			adapters = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						name = "gemini_custom", -- Give this adapter a different name to differentiate it from the default ollama adapter
						schema = {
							model = {
								default = "gemini-2.0-flash",
							},
							temperature = {
								default = 1,
							},
							topP = {
								default = 0.95,
							},
						},
					})
				end,
			},
		})
		vim.keymap.set(
			{ "n", "v" },
			"<leader>a<Tab>",
			"<cmd>CodeCompanionActions<cr>",
			{ noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>aa",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ noremap = true, silent = true }
		)
		vim.keymap.set("v", "<leader>ai", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

		-- Expand 'cc' into 'CodeCompanion' in the command line
		vim.cmd([[cab cc CodeCompanion]])
	end,
}
