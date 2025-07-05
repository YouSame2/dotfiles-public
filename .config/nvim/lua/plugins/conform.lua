-- credit: github.com/josean-dev
return {
	"stevearc/conform.nvim",
	cond = not vim.g.vscode,
	dependencies = { "mason.nvim" },
	event = "VeryLazy",
	config = function()
		local conform = require("conform")

		-- HACK: fixes space in windows username
		local function get_formatters()
			local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
			local formatters = {}
			local mason_dir = "C:\\Users\\PATRIC~1\\AppData\\Local\\nvim-data\\mason\\bin\\"

			if is_windows then
				-- NOTE: later found out not all have issues? leaving others just incase
				formatters.stylua = {
					command = mason_dir .. "stylua.cmd",
				}
				formatters.shfmt = {
					command = mason_dir .. "shfmt.cmd",
				}
				formatters.ruff_format = {
					command = mason_dir .. "ruff.cmd",
				}
				-- formatters.prettier = {
				-- 	command = mason_dir .. "prettier.cmd",
				-- }
				-- formatters.isort = {
				-- 	command = mason_dir .. "isort.cmd",
				-- }
				-- formatters.black = {
				-- 	command = mason_dir .. "black.cmd",
				-- }
			end

			-- formatter settings for both mac and windows
			formatters.ruff = {
				append_args = { "--extend-select", "I", "--extend-ignore", "F401" }, -- sort imports & ignore unused imports rule
			}

			return formatters
		end

		conform.setup({
			-- default_format_opts = function ()
			--   -- function to set the default command passing the mason dir and whatever formater is being used
			-- end,
			formatters_by_ft = {
				-- javascript = { "prettier" },
				-- typescript = { "prettier" },
				-- javascriptreact = { "prettier" },
				-- typescriptreact = { "prettier" },
				-- svelte = { "prettier" },
				-- css = { "prettier" },
				-- html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				-- graphql = { "prettier" },
				-- liquid = { "prettier" },
				lua = { "stylua" },
				bash = { "beautysh" },
				sh = { "shfmt" },
				python = { "ruff_format" },
			},
			formatters = get_formatters(),
			format_on_save = {
				lsp_fallback = false,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>gf", function()
			conform.format({
				lsp_fallback = false,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "format documant (conform)" })
	end,
}
