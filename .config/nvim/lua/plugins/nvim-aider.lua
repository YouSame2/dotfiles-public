return {
	"GeorgesAlkhouri/nvim-aider",
	enabled = false,
	cmd = "Aider",
	-- Example key mappings for common actions:
	keys = {
		{ "<leader>aa", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
		{ "<leader>a<Tab>", "<cmd>Aider command<cr>", desc = "Aider Commands" },
		{ "<leader>ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
		{ "<leader>a+", "<cmd>Aider add<cr>", desc = "Add File" },
		{ "<leader>a-", "<cmd>Aider drop<cr>", desc = "Drop File" },
		{ "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
	},
	dependencies = {
		"folke/snacks.nvim",
		--- The below dependencies are optional
		-- "catppuccin/nvim",
		-- "nvim-tree/nvim-tree.lua",
	},
	opts = {
		auto_reload = true,
		-- default colors have syntax highlighting for code
		theme = {
			user_input_color = "",
			tool_output_color = "",
			tool_error_color = "",
			tool_warning_color = "",
			assistant_output_color = "",
			completion_menu_color = "",
			completion_menu_bg_color = "",
			completion_menu_current_color = "",
			completion_menu_current_bg_color = "",
		},
		win = {
			width = 0.5,
		},
	},
}
