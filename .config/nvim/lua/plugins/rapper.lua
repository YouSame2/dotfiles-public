return {
	enabled = false,
	dir = "~/Repos/Personal/rapper.nvim",
	-- lazy = false,
	cmd = "Testy",
	name = "rapper",
	config = function()
		require("rapper").setup()
	end,
}
