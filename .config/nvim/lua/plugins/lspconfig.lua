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
		"j-hui/fidget.nvim",
	},

	config = function()
		-- Diagnostics {{{
		local diagnostic_config = {
			virtual_text = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "󰠠",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		}
		vim.diagnostic.config(diagnostic_config)
		-- }}}

		-- Disable the default keybinds {{{
		for _, bind in ipairs({ "grn", "gra", "gri", "grr" }) do
			pcall(vim.keymap.del, "n", bind)
		end
		-- }}}

		-- LSP keymaps only after LSP Attach {{{
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("LSP", { clear = true }),
			callback = function(ev)
				local bufnr = ev.buf

				local function opts(desc)
					return { buffer = bufnr, desc = "LSP: " .. desc }
				end
				-- keymaps
				vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts("[g]oto [d]efinition"))
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("[g]oto [D]eclaration"))
				vim.keymap.set(
					"n",
					"gi",
					require("telescope.builtin").lsp_implementations,
					opts("[g]oto [i]mplementation")
				)
				vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts("[g]oto [I]mplementation"))
				vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts("[g]oto [r]eferences"))
				vim.keymap.set("n", "gR", vim.lsp.buf.references, opts("[g]oto [R]eferences"))
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("[w]orkspace [a]dd folder"))
				vim.keymap.set(
					"n",
					"<leader>wr",
					vim.lsp.buf.remove_workspace_folder,
					opts("[w]orkspace [r]emove folder")
				)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts("[w]orkspace [l]ist folders"))
				vim.keymap.set(
					"n",
					"<leader>gt",
					require("telescope.builtin").lsp_type_definitions,
					opts("[g]oto [t]ype definition")
				)
				vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition, opts("[g]oto [T]ype definition"))
				-- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("[c]ode [a]ction")) -- using telescope UI select @ ./extras.lua
				vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts("smart [c]ode [r]ename"))
				vim.keymap.set(
					"n",
					"<leader>cd",
					"<cmd>Telescope diagnostics bufnr=0<CR>",
					opts("show [c]ode [d]iagnostics")
				)
				vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, opts("show [c]ode [s]ignature help"))
			end,
		})
		-- }}}

		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			automatic_enable = true,
		})

		-- Servers {{{

		-- Lua
		vim.lsp.config.lua_ls = {
			settings = {
				Lua = {
					telemetry = {
						enable = false,
					},
					diagnostics = {
						globals = { "vim" }, -- recognize "vim" global
					},
				},
			},
		}

		-- Python
		-- NOTE: auto venv and pythonPath setup in autocmd
		vim.lsp.config.pyright = {
			settings = {
				pyright = {
					disableOrganizeImports = true, -- Using Ruff's import organizer
				},
				python = {
					analysis = {
						ignore = { "*" }, -- Ignore all files for analysis to exclusively use Ruff for linting
					},
				},
			},
			-- on_attach = function(args)
			-- 	local client = vim.lsp.get_client_by_id(args.data.client_id)
			-- 	if client == nil then
			-- 		return
			-- 	end
			-- 	if client.name == "ruff" then
			-- 		-- Disable hover in favor of LSP
			-- 		client.server_capabilities.hoverProvider = false
			-- 	end
			-- end,
		}
		vim.lsp.config.pylsp = {
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
			-- on_attach = function(args)
			-- 	local client = vim.lsp.get_client_by_id(args.data.client_id)
			-- 	if client == nil then
			-- 		return
			-- 	end
			-- 	if client.name == "ruff" then
			-- 		-- Disable hover in favor of LSP
			-- 		client.server_capabilities.hoverProvider = false
			-- 	end
			-- end,
		}

		-- }}}

		-- HACK: since im VeryLazy loading, it prevents lspstart when starting nvim in a file. running ':edit' after vimenter fixes this
		-- PS YES IM CHASING STARTTIMES!!!
		vim.schedule(function()
			pcall(vim.cmd, "edit")
		end)
	end,
}
