-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	change_detection = {
		notify = false, -- dont notify when changes are found
	},
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	defaults = {
		lazy = true,
		version = false, -- always use the latest git commit
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "retrobox" } },
	-- automatically check for plugin updates
	checker = { enabled = false },
	performance = {
		rtp = {
			-- Disable some rtp plugins
			disabled_plugins = {
				"bugreport", -- Provides `:bugreport` command for Neovim issues
				"gzip", -- Support for opening .gz files
				-- "matchit",         -- Enhanced % navigation for matching pairs
				-- "matchparen",      -- Highlights matching parentheses
				"tar", -- Core support for .tar files
				"tarPlugin", -- Enables reading .tar archives
				"tutor", -- Provides vimtutor inside Neovim
				"vimball", -- Saves multiple files into a .vba archive
				"vimballPlugin", -- Enables extracting .vba archives
				"zip", -- Core support for .zip files
				"zipPlugin", -- Enables browsing/editing .zip files
				-- From NvChad
				"tohtml", -- Converts files to HTML with syntax highlighting
				"2html_plugin", -- Converts buffers to an HTML file
				"getscript", -- Download Vim scripts from vim.org
				"getscriptPlugin", -- Enhances getscript functionality
				"logipat", -- Old Vim pattern matching helper (unused)
				"netrw", -- Core file explorer
				"netrwPlugin", -- Plugin features for netrw
				"netrwSettings", -- Configuration settings for netrw
				"netrwFileHandlers", -- Handles file types in netrw
				"rrhelper", -- Developer helper for debugging Vim scripts
				-- "spellfile_plugin", -- Loads custom spell files
				-- "rplugin",         -- Remote plugin support (e.g., Python plugins)
				-- "syntax",          -- Syntax highlighting (disabling removes colors!)
				-- "synmenu",         -- GUI syntax highlight menu (for Vim GUI)
				-- "optwin",          -- GUI-like options window
				-- "compiler",        -- Custom compiler settings for `:make`
			},
		},
	},
})
