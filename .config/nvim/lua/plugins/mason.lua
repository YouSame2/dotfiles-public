-- NOTE: all mason plugins are in here its important to load in this order:
-- mason, mason-lspconfig, then setup lspconfig.
-- mason tool installer is for bootstrapping formatters/linters
return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		cond = not vim.g.vscode,
		config = function()
			local mason = require("mason")
			-- enable mason and configure icons
			mason.setup({
				-- PATH = "skip",
				PATH = "prepend",
				ui = {
					icons = {
						package_pending = " ",
						package_installed = " ",
						package_uninstalled = " ",
					},
				},
				max_concurrent_installers = 10,
			})
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		cond = not vim.g.vscode,
		dependencies = {
			"williamboman/mason.nvim",
		},

		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			-- setup mason-lspconfig
			mason_lspconfig.setup({
				automatic_installation = false,
				ensure_installed = { -- bootstrap: uncomment on first run
					"lua_ls",
					"ts_ls",
					"html",
					"bashls",
					"pyright",
					-- "pylsp",
					-- "cssls",
					-- "tailwindcss",
					-- "svelte",
					-- "graphql",
					-- "emmet_ls",
					-- "prismals",
				},
			})
		end,
	},

	-- bootstrap: uncomment on first run
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		event = "VeryLazy",
		cond = not vim.g.vscode,
		-- lazy = false,
		config = function()
			local mason_tool_installer = require("mason-tool-installer")
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"shfmt",
					"ruff",
					-- "shellcheck",
					-- "isort",
					-- "black",
					-- "pylint",
					{ "eslint_d", version = "13.1.2" }, -- v14.0.3 is bugged stick with this till fix
				},
			})
		end,
	},
}
