return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	build = ":TSUpdate",

	init = function(plugin)
		-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
		-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
		-- no longer trigger the **nvim-treesitter** module to be loaded in time.
		-- Luckily, the only things that those plugins need are the custom queries, which we make available
		-- during startup.
		require("lazy.core.loader").add_to_rtp(plugin)
		require("nvim-treesitter.query_predicates")
		-- specific for windows. docs say to use curl instead (recommended)
		require("nvim-treesitter.install").prefer_git = false
	end,

	config = function()
		require("nvim-treesitter.configs").setup({
			-- ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "diff", "html", "json", "jsonc", "python", "regex", "toml", "yaml", "gitignore", "vim", "vimdoc", }, -- bootstrap: uncomment on first run
			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,
			indent = {
				enable = true,
			},
			highlight = {
				enable = true,
				-- NOTE: enable below function if running into performance issues on large files:

				-- disable = function(lang, buf)
				-- 	local max_filesize = 100 * 1024 -- 100 KB
				-- 	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				-- 	if ok and stats and stats.size > max_filesize then
				-- 		return true
				-- 	end
				-- end,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<C-S-space>",
					node_decremental = "<C-H>", -- H = backspace
				},
			},
		})
	end,
}
