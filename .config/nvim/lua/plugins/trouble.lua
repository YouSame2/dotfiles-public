return {
	"folke/trouble.nvim",
	cmd = { "Trouble" },
	cond = not vim.g.vscode,
	opts = {
		modes = {
			lsp = {
				win = { position = "right" },
			},
		},
	},
	keys = {
		{ "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", desc = "[t]oggle [t]rouble diagnostics" },
		{
			"<leader>tb",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "toggle [t]rouble [b]uffer diagnostics",
		},
		{ "<leader>ts", "<cmd>Trouble symbols toggle win.size=.5<cr>", desc = "toggle [t]rouble [s]ymbols" },
		{ "<leader>tS", "<cmd>Trouble lsp toggle<cr>", desc = "toggle [t]rouble L[S]P references/definitions/..." },
		{ "<leader>tl", "<cmd>Trouble loclist toggle<cr>", desc = "toggle [t]rouble [l]ocation list" },
		{ "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "toggle [t]rouble [q]uickfix list" },
		{
			"[q",
			function()
				if require("trouble").is_open() then
					require("trouble").prev({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cprev)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
				vim.schedule(function()
					require("go-up").centerScreen()
				end)
			end,
			desc = "previous trouble/quickfix item",
		},
		{
			"[Q",
			function()
				if require("trouble").is_open() then
					require("trouble").first({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cfir)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
				vim.schedule(function()
					require("go-up").centerScreen()
				end)
			end,
			desc = "first trouble/quickfix item",
		},
		{
			"]q",
			function()
				if require("trouble").is_open() then
					require("trouble").next({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cnext)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
				vim.schedule(function()
					require("go-up").centerScreen()
				end)
			end,
			desc = "next trouble/quickfix item",
		},
		{
			"]Q",
			function()
				if require("trouble").is_open() then
					require("trouble").last({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cla)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
				vim.schedule(function()
					require("go-up").centerScreen()
				end)
			end,
			desc = "last trouble/quickfix item",
		},
	},
}
