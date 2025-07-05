return {
	{
		"okuuva/auto-save.nvim",
		cmd = "ASToggle", -- optional for lazy loading on command
		cond = not vim.g.vscode,
		event = "VeryLazy",
		opts = {
			enabled = true,
			noautocmd = true, -- prevent autoformat on autosave
			trigger_events = {
				immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
				defer_save = {
					"InsertLeave",
					"TextChanged",
				},
				cancel_deferred_save = {
					"InsertEnter",
				},
			},
			condition = function(buf)
				local mode = vim.fn.mode()
				if mode == "i" then
					return false
				end

				-- -- Disable auto-save for the harpoon plugin, otherwise it just opens and closes
				-- -- https://github.com/ThePrimeagen/harpoon/issues/434
				-- -- Run `:set filetype?` on a dadbod query to make sure of the filetype
				-- local filetype = vim.bo[buf].filetype
				-- if filetype == "harpoon" or filetype == "mysql" then
				-- 	return false
				-- end

				-- Skip autosave if you're in an active snippet
				if require("luasnip").in_snippet() then
					return false
				end

				return true
			end,
			debounce_delay = 1000,
		},
	},
}
