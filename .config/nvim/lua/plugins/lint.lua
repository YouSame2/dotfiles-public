return {
	"mfussenegger/nvim-lint",
	event = "VeryLazy",
	cond = not vim.g.vscode,
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			-- python = { "ruff" }, -- NOTE: ruff is an lsp. conform runs ruff formatter and linter from my testing. enabling here will produce duplicate lints
			-- sh = { "shellcheck" }, -- NOTE: bashls includes shellcheck. enabling will produce duplicate diagnostics
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "gl", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
