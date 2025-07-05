return {
	"nvim-telescope/telescope.nvim",
	cond = not vim.g.vscode,
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- faster sorting
	},

	cmd = "Telescope", -- cmd will lazy load Telescope

	keys = {
		-- FIND KEYMAPS
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "[f]ind [h]elp",
		},
		{
			"<leader>fk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "[f]ind [k]eymaps",
		},
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "[f]ind [f]iles",
		},
		{
			-- find files in git root dir with fall back if no git repo
			"<leader>fF",
			function()
				local function is_git_repo()
					vim.fn.system("git rev-parse --is-inside-work-tree")

					return vim.v.shell_error == 0
				end

				local function get_git_root()
					local dot_git_path = vim.fn.finddir(".git", ".;")
					return vim.fn.fnamemodify(dot_git_path, ":h")
				end

				local opts = {}

				if is_git_repo() then
					opts = {
						cwd = get_git_root(),
					}
				end

				require("telescope.builtin").find_files(opts)
			end,
			desc = "[f]ind [F]iles root",
		},
		{
			"<leader>f<Tab>",
			function()
				require("telescope.builtin").builtin()
			end,
			desc = "[f]ind telescope builtins",
		},
		{
			"<leader>fd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "[f]ind [d]iagnostics",
		},
		{ "<leader>fD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "[f]ind [d]iagnostics workspace" },
		{
			"<leader>fr",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "[f]ind [r]esume",
		},
		{
			"<leader>f.",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = "[f]ind Recent Files",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "[f]ind [b]uffers",
		},
		{
			"<leader>fn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			{ desc = "[f]ind [n]eovim files" },
		},

		{
			"<leader>fN",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
			end,
			desc = "[f]ind [N]eovim plugin files",
		},
		{ "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "[f]ind [:]command History" },
		{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "[f]ind [g]it files" },
		{ "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "[f]ind [g]it [c]ommits" },
		-- { "<leader>fgs", "<cmd>Telescope git_status<CR>", desc = "[f]ind [g]it [s]tatus" }, -- using my extension instead
		{ '<leader>f"', "<cmd>Telescope registers<cr>", desc = "[f]ind registers" },
		-- GREP KEYMAPS
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find()
			end,
			desc = "[/] Fuzzily search in current buffer",
		},
		{
			"<leader>sw",
			function()
				require("telescope.builtin").grep_string()
			end,
			desc = "[s]earch current [w]ord",
		},
		{
			"<leader>ss",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "[s]earch by grep",
		},
		{
			-- find by grep in git root dir with fall back if no git repo
			"<leader>sS",
			function()
				local function is_git_repo()
					vim.fn.system("git rev-parse --is-inside-work-tree")

					return vim.v.shell_error == 0
				end

				local function get_git_root()
					local dot_git_path = vim.fn.finddir(".git", ".;")
					return vim.fn.fnamemodify(dot_git_path, ":h")
				end

				local opts = {}

				if is_git_repo() then
					opts = {
						cwd = get_git_root(),
					}
				end

				require("telescope.builtin").live_grep(opts)
			end,
			desc = "[s]earch by grep root",
		},
		{ "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "[s]earch [q]uickfix List" },
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local config = require("telescope.config")
		---@diagnostic disable-next-line: deprecated
		local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }
		local open_with_trouble = require("trouble.sources.telescope").open
		-- local add_to_trouble = require("trouble.sources.telescope").add -- Use this to add more results without clearing the trouble list

		-- change default grep args to show hidden but not .git/
		table.insert(vimgrep_arguments, "--hidden") -- `hidden = true` is not supported in text grep commands.
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")

		telescope.setup({

			--       sorting_strategy = "ascending",
			--       layout_strategy = "bottom_pane",
			--       layout_config = {
			--           height = 25,
			--         },

			defaults = {
				defaults = { require("telescope.themes").get_ivy({}) },
				path_display = { "smart" },
				prompt_prefix = "   ",
				selection_caret = " ",
				entry_prefix = " ",
				vimgrep_arguments = vimgrep_arguments,
				extensions = {
					fzf = {},
				},
				-- DEFAULT THEME STUFF
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
					width = 0.87,
					height = 0.80,
				},
				-- -- IVY THEME STUFF
				-- layout_strategy = "bottom_pane",
				-- sorting_strategy = "descending",
				-- layout_config = {
				-- 	preview_width = 0.62,
				-- 	prompt_position = "bottom",
				-- 	height = 0.50,
				-- },
				-- border = true,
				-- borderchars = {
				-- 	prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				-- 	results = { "─", " ", " ", "│", "╭", "─", " ", " " },
				-- 	preview = { "─", "│", " ", "│", "─", "╮", "│", "│" },
				-- },
				mappings = {
					n = { ["q"] = actions.close, ["<c-t>"] = open_with_trouble },
					i = {
						["<esc>"] = actions.close,
						["<C-j>"] = require("telescope.actions").move_selection_next,
						["<C-k>"] = require("telescope.actions").move_selection_previous,
						["<c-t>"] = open_with_trouble,
					},
				},
			},
			pickers = {
				buffers = {
					mappings = {
						i = {
							["<c-d>"] = actions.delete_buffer,
						},
					},
				},
				find_files = {
					-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
					find_command = { "rg", "--files", "--hidden", "--glob", "!{**/.git/*,node_modules/*}" }, -- other useful globs: ",.next/*,.svelte-kit/*,target/*"
				},
				help_tags = {
					mappings = {
						i = {
							["<CR>"] = require("telescope.actions").select_vertical,
						},
					},
				},
			},
		})

		require("telescope").load_extension("fzf")
	end,
}
--[[ OTHER EXAMPLES

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })


]]
