return {
	"zbirenbaum/copilot.lua",
	cond = not vim.g.vscode,
	cmd = "Copilot",
	keys = {
		{
			"<leader>ac",
			function()
				vim.cmd("Copilot suggestion toggle_auto_trigger")
				require("fidget").notify("Copilot Toggled")
			end,
			desc = "Toggle ai [a]uto [c]omplete",
		},
	},
	opts = {
		suggestion = {
			hide_during_completion = false,
			debounce = 150,
			keymap = {
				accept = "<C-y>", -- can accept behind cmp, also temp enables copilot 1 time
				next = "<C-n>",
				prev = "<C-p>",
				dismiss = "<C-e>", -- 1st press dismiss cmp 2nd press dismiss copilot
			},
		},
		panel = {
			enabled = false,
			auto_refresh = false,
		},
		filetypes = {
			yaml = false,
			markdown = false,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			AiderConsole = false,
			Avante = false,
			TelescopePrompt = false,
		},
		copilot_model = "gpt-4o-copilot", -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
		should_attach = function(_, bufname)
			if string.match(bufname, "env") then
				return false
			end
		end,
		server_opts_overrides = {
			settings = {
				telemetry = {
					telemetryLevel = "off",
				},
			},
		},
	},
}
