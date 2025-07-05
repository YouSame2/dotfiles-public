return {
	"joshuavial/aider.nvim",
	enabled = false,
	cond = not vim.g.vscode,
	cmd = { "AiderOpen", "AiderAddModifiedFiles" },
	keys = {
		{
			"<leader>aa",
			"<cmd>AiderOpen<CR>",
			desc = "Toggle [a]ider [a]i",
		},
		{
			"<leader>af",
			"<cmd>AiderAddModifiedFiles<CR>",
			desc = "[a]ider add [f]iles",
		},
	},
	opts = {
		default_bindings = false, -- use default <leader>A keybindings
		auto_manage_context = true, -- automatically manage buffer context
		debug = false, -- enable debug logging
		auto_refresh_buffers = true,
		auto_save_on_leave = true,
		auto_reload_on_aider_leave = true,
	},

	-- config = function()
	-- 	local aider = require("aider")

	-- 	aider.setup({
	-- 		auto_manage_context = true, -- automatically manage buffer context
	-- 		debug = false, -- enable debug logging
	-- 	})
	-- end,
}
