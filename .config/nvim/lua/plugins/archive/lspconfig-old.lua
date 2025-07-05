return {
	"neovim/nvim-lspconfig",
	cond = not vim.g.vscode,
	event = "VeryLazy",

	-- NOTE: order must go: mason, mason-lspconfig, blink, then lspconfig
	dependencies = {
		-- "hrsh7th/cmp-nvim-lsp", -- using blink instead
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},

	config = function()
		-- == LSP keymaps only after LSP Attach == --
		local on_attach_keys = function(_, bufnr)
			local keymap = vim.keymap
			local function opts(desc)
				return { buffer = bufnr, desc = "LSP: " .. desc }
			end
			-- keymaps
			keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts("[g]oto [d]efinition"))
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts("[g]oto [D]eclaration"))
			keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, opts("[g]oto [i]mplementation"))
			keymap.set("n", "gI", vim.lsp.buf.implementation, opts("[g]oto [I]mplementation"))
			keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts("[g]oto [r]eferences"))
			keymap.set("n", "gR", vim.lsp.buf.references, opts("[g]oto [R]eferences"))
			keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("[w]orkspace [a]dd folder"))
			keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("[w]orkspace [r]emove folder"))
			keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts("[w]orkspace [l]ist folders"))
			keymap.set(
				"n",
				"<leader>gt",
				require("telescope.builtin").lsp_type_definitions,
				opts("[g]oto [t]ype definition")
			)
			keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition, opts("[g]oto [T]ype definition"))
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("[c]ode [a]ction"))
			keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts("smart [c]ode [r]ename"))
			keymap.set("n", "<leader>cd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts("show [c]ode [d]iagnostics"))
			keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, opts("show [c]ode [s]ignature help"))
		end

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Diagnostics {{{
		local config = {
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		}
		vim.diagnostic.config(config)
		-- }}}

		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- == Configure LSP servers == --
		mason_lspconfig.setup_handlers({
			function(server_name) -- Default handler (all servers)
				lspconfig[server_name].setup({
					on_attach = on_attach_keys,
					capabilities = capabilities,
				})
			end,
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					on_attach = on_attach_keys,
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" }, -- recognize "vim" global
							},
						},
					},
				})
			end,
			["pylsp"] = function()
				lspconfig["pylsp"].setup({
					on_attach = on_attach_keys,
					capabilities = capabilities,
					settings = {
						pylsp = {
							plugins = { -- disable all plugins if using ruff
								pyflakes = { enabled = false },
								pycodestyle = { enabled = false },
								autopep8 = { enabled = false },
								yapf = { enabled = false },
								mccabe = { enabled = false },
								pylsp_mypy = { enabled = false },
								pylsp_black = { enabled = false },
								pylsp_isort = { enabled = false },
							},
						},
					},
				})
			end,
			-- ["emmet_ls"] = function()
			--   lspconfig["emmet_ls"].setup({
			--     capabilities = capabilities,
			--     filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
			--   })
			-- end,
		})

		-- HACK: since im VeryLazy loading, it prevents lspstart when starting nvim in a file. so start manuelly.
		vim.cmd("LspStart")
	end,
}
