return {
	"saghen/blink.cmp",
	cond = not vim.g.vscode,
	event = "VeryLazy",
	dependencies = {
		"rafamadriz/friendly-snippets",
		{ "saghen/blink.compat", version = "*", opts = {} }, -- for avante
		{
			"L3MON4D3/LuaSnip",
			config = function()
				local ls = require("luasnip")

				-- idk but luasnip said to do this.
				snip_env = {
					s = function(...)
						local snip = ls.s(...)
						table.insert(getfenv(2).ls_file_snippets, snip)
					end,
					parse = function(...)
						local snip = ls.parser.parse_snippet(...)
						table.insert(getfenv(2).ls_file_snippets, snip)
					end,
				}

				require("luasnip.loaders.from_lua").lazy_load({
					paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
				})
			end,
		},
	},
	version = "*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		enabled = function()
			-- add any filetypes to disable cmp here
			local disabled_filetypes = {
				TelescopePrompt = true, -- speed up telescope
				markdown = true,
				-- minifiles = true,
				-- snacks_picker_input = true,
			}
			-- check if command mode is a shell cmd (i.e. [ ":!" , ":%!" ]) to disable cmp for proformance
			local function not_shellcmd()
				if vim.fn.getcmdtype() ~= ":" then -- speed optimization for searches
					return true
				else
					return not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
				end
			end
			return not disabled_filetypes[vim.bo[0].filetype]
				-- and vim.bo.buftype ~= "prompt"
				and vim.b.completion ~= false
				and not_shellcmd()
		end,

		keymap = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			preset = "super-tab",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
			["<C-d>"] = { "scroll_documentation_up", "fallback" },
			["<C-u>"] = { "scroll_documentation_down", "fallback" },
			["<c-j>"] = { "select_next", "fallback" },
			["<c-k>"] = { "select_prev", "fallback" },
		},

		-- recent change hide cmdline cmp, these are now needed for cmdline cmp
		cmdline = {
			completion = { menu = { auto_show = true } },
			keymap = {
				preset = "super-tab",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
				["<C-d>"] = { "scroll_documentation_up", "fallback" },
				["<C-u>"] = { "scroll_documentation_down", "fallback" },
				["<c-j>"] = { "select_next", "fallback" },
				["<c-k>"] = { "select_prev", "fallback" },
			},
		},

		completion = {
			list = {
				selection = { preselect = true, auto_insert = false },
			},
			-- keyword range doc:
			-- 'prefix' will fuzzy match on the text before the cursor
			-- 'full' will fuzzy match on the text before *and* after the cursor
			-- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
			keyword = {
				range = "full",
			},
			documentation = { window = { border = "rounded" } },
		},

		snippets = { preset = "luasnip" }, -- only if using luasnip

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"avante_commands",
				"avante_mentions",
				"avante_files",
			},
			providers = {
				-- below for avante
				avante_commands = {
					name = "avante_commands",
					module = "blink.compat.source",
					score_offset = 90, -- show at a higher priority than lsp
					opts = {},
				},
				avante_files = {
					name = "avante_files",
					module = "blink.compat.source",
					score_offset = 100, -- show at a higher priority than lsp
					opts = {},
				},
				avante_mentions = {
					name = "avante_mentions",
					module = "blink.compat.source",
					score_offset = 1000, -- show at a higher priority than lsp
					opts = {},
				},
			},
			-- below for codecompanion
			per_filetype = {
				codecompanion = { "codecompanion" },
			},
		},

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = false,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},
	},
	opts_extend = { "sources.default" },
}
