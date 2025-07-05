return {
	"nvimtools/none-ls.nvim",
	enabled = false,
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		local null_ls = require("null-ls")
		local code_actions = null_ls.builtins.code_actions
		local diagnostics = null_ls.builtins.diagnostics
		local formatting = null_ls.builtins.formatting
		local hover = null_ls.builtins.hover
		local completion = null_ls.builtins.completion

		-- NOTE: windows null-ls is werid. spent days tinna figure it out.
		-- because of spaces in PATH and my username for mason formatters
		-- the path doesnt get properly expanded so i need to specify path
		-- to mason installs for windows. if you find a better way plz lmk!

		-- Detect OS
		local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
		local function modify_source(source)
			if is_windows then
				local source_file = "C:\\Users\\PATRIC~1\\AppData\\Local\\nvim-data\\mason\\bin\\"
					.. source.name
					.. ".cmd"
				return source.with({ command = source_file })
			end
			return source -- Return unchanged for non-Windows
		end

		null_ls.setup({
			-- debug = true,
			sources = {
				-- General
				modify_source(formatting.prettier),
				-- completion.spell,

				-- Lua
				modify_source(formatting.stylua),
			},
		})
	end,

	vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {}),
}
