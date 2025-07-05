return {
	"akinsho/git-conflict.nvim",
	cond = not vim.g.vscode,
	version = "*",
	event = "VeryLazy",
	keys = {
		{
			"<leader>gmc",
			function()
				vim.cmd("GitConflictListQf")
			end,
			desc = "git merge conflict qf",
		},
	},
	config = function()
		-- set notification
		local ok, fidget = pcall(require, "fidget")
		if ok then
			vim.notify = fidget.notify
		end

		require("git-conflict").setup({
			default_mappings = true, -- enable buffer local mapping created by this plugin
			default_commands = true, -- enable commands created by this plugin
			disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
			list_opener = "copen", -- command or function to open the conflicts list
			highlights = { -- They must have background color, otherwise the default color will be used
				incoming = "DiffAdd",
				current = "DiffChange",
			},
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "GitConflictDetected",
			callback = function()
				vim.notify("Conflict detected in file " .. vim.api.nvim_buf_get_name(0))
				vim.cmd("LspStop")
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "GitConflictResolved",
			callback = function()
				vim.notify("Conflict Resolved")
				vim.cmd("LspRestart")
			end,
		})

		-- HACK: fixes lazy loading plugin
		vim.cmd("GitConflictRefresh")
	end,
}
