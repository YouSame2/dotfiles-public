return {
	"yetone/avante.nvim",
	-- enabled = false,
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		-- "zbirenbaum/copilot.lua", -- for providers='copilot'
		-- {
		--   -- support for image pasting
		--   "HakonHarnes/img-clip.nvim",
		--   event = "VeryLazy",
		--   opts = {
		--     -- recommended settings
		--     default = {
		--       embed_image_as_base64 = false,
		--       prompt_for_file_name = false,
		--       drag_and_drop = {
		--         insert_mode = true,
		--       },
		--       -- required for Windows users
		--       use_absolute_path = true,
		--     },
		--   },
		-- },
	},
	opts = {
		-- add any opts here
		-- for example
		provider = "gemini",
		file_selector = {
			--- @alias FileSelectorProvider "native" | "fzf" | "telescope" | string
			provider = "telescope",
			-- Options override for custom providers
			provider_opts = {},
		},
		gemini = {
			model = "gemini-1.5-flash",
			-- model = "gemini-2.0-flash", -- your desired model (or use gpt-4o, etc.)
			temperature = 1,
		},
		openai = {
			endpoint = "https://api.openai.com/v1",
			model = "gpt-4o-mini", -- your desired model (or use gpt-4o, etc.)
			timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
			temperature = 0,
			max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
			--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
		},
		cursor_applying_provider = "gemini",
		behaviour = {
			enable_cursor_planning_mode = true,
		},
		windows = {
			---@type "right" | "left" | "top" | "bottom"
			position = "right", -- the position of the sidebar
			wrap = true, -- similar to vim.o.wrap
			width = 50, -- default % based on available width
			sidebar_header = {
				enabled = true, -- true, false to enable/disable the header
				align = "center", -- left, center, right for title
				rounded = true,
			},
		},
	},
}
