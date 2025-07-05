return {
	"norcalli/nvim-colorizer.lua",
	cond = not vim.g.vscode,
	event = "VeryLazy",
	config = function()
		require("colorizer").setup({ "*" }, {
			RGB = true, -- #RGB hex codes
			RRGGBB = true, -- #RRGGBB hex codes
			names = true, -- "Name" codes like Blue
			RRGGBBAA = true, -- #RRGGBBAA hex codes
			rgb_fn = true, -- CSS rgb() and rgba() functions
			hsl_fn = true, -- CSS hsl() and hsla() functions
			css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
			css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn)
		})
	end,
}

-- #f0f
-- #ff00ffff
-- Magenta
-- #ff00ff
-- rgb(255,0,255)
-- rgba(255,0,255,0.40)
-- hsl(300,100%,50%)
-- hsla(300,100%,50%,0.40)
