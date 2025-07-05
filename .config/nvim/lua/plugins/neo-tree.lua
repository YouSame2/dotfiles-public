return {
	"nvim-neo-tree/neo-tree.nvim",
	cond = not vim.g.vscode,
	branch = "v3.x",
	-- version = "3.29",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",

	keys = {
		{
			"<leader>e",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
			end,
			desc = "Explorer (cwd)",
		},
		{
			"<leader>E",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd(), reveal = true })
			end,
			desc = "Explorer Cur Buf (cwd)",
		},
	},

	opts = {
		sources = { "filesystem" },
		popup_border_style = "rounded",
		close_if_last_window = true,
		enable_git_status = true,
		enable_diagnostics = false,
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = false },
			use_libuv_file_watcher = true,
			group_empty_dirs = true,
			filtered_items = {
				visible = true, -- when true, they will just be displayed differently than normal items
			},
		},
		window = {
			mappings = {
				["l"] = "open",
				["h"] = "close_node",
				["<space>"] = "none",
				["Y"] = {
					function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.fn.setreg("+", path, "c")
					end,
					desc = "Copy Path to Clipboard",
				},
				["O"] = {
					function(state)
						require("lazy.util").open(state.tree:get_node().path, { system = true })
					end,
					desc = "Open with System Application",
				},
				["P"] = { "toggle_preview", config = { use_float = true } },
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				-- expander_collapsed = "",
				-- expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
				with_markers = false,
			},
			git_status = {
				symbols = {
					unstaged = "󰄱",
					staged = "󰱒",
				},
			},
			icon = {
				default = "",
			},
		},
	},

	config = function(_, opts)
		-- -- If you use snacks.rename instead of file operators
		-- local function on_move(data)
		--   local snacks = require("snacks")
		--   snacks.rename.on_rename_file(data.source, data.destination)
		-- end
		--
		-- local events = require("neo-tree.events")
		-- opts.event_handlers = opts.event_handlers or {}
		-- vim.list_extend(opts.event_handlers, {
		--   { event = events.FILE_MOVED, handler = on_move },
		--   { event = events.FILE_RENAMED, handler = on_move },
		-- })
		require("neo-tree").setup(opts)
		-- refresh git_status on lazygit close
		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "*lazygit",
			callback = function()
				if package.loaded["neo-tree.sources.git_status"] then
					require("neo-tree.sources.git_status").refresh()
				end
			end,
		})
	end,
}
