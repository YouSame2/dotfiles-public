return {
	"echasnovski/mini.nvim",
	version = false,
	event = "VeryLazy",
	config = function()
		-- MINI.COMMENT
		require("mini.comment").setup({
			options = {
				ignore_blank_line = true, -- THANK GOD!
			},
		})
		require("mini.splitjoin").setup({ mappings = { toggle = "sj" } })

		-- MINI.SURROUND
		require("mini.surround").setup({
			-- NOTE from my experience just use mini.ai to get were u need to go
			-- visually, then do surround. unless its something close or easy
			-- things get wonky if you try doing complex surrounds.
			highlight_duration = 800,
			n_lines = 500,
		})

		-- MINI.AI
		-- setup custom textobjects:
		local ai = require("mini.ai")
		local custom_txtobj = {
			o = ai.gen_spec.treesitter({ -- code block/object
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}),
			f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
			c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
			m = ai.gen_spec.treesitter({ a = "@call.outer", i = "@call.inner" }), -- function
			-- M = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
			-- t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },        -- tags
			-- d = { "%f[%d]%d+" },                                                       -- digits
			-- e = {                                                                      -- Word with case
			--   { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
			--   "^().*()$",
			-- },
		}
		require("mini.ai").setup({
			-- search_method = "cover", -- vib will select the brack u are currently in vinb will do next bracket
			mappings = {
				goto_left = "", -- disabling cuz dont like this functionality
				goto_right = "",
			},
			n_lines = 500,
			custom_textobjects = custom_txtobj,
		})
		-- NOTE: i found the below in mini's discussions. thought i would like it but
		-- turns out to be annoying to navigate textobjects like this. just stick to treesitter.
		--
		-- local map_nextlast_motion = function(lhs, side, search_method)
		--   local rhs = function()
		--     MiniAi.move_cursor(side, 'a', vim.fn.getcharstr(), { search_method = search_method, n_times = vim.v.count1 })
		--   end
		--   local desc = 'Go to ' .. side .. ' side of ' .. search_method .. ' textobject'
		--   vim.keymap.set({ 'n', 'x', 'o' }, lhs, rhs, { desc = desc })
		-- end
		-- map_nextlast_motion('g[n', 'left', 'next')
		-- map_nextlast_motion('g]n', 'right', 'next')
		-- map_nextlast_motion('g[l', 'left', 'prev')
		-- map_nextlast_motion('g]l', 'right', 'prev')

		-- MINI.INDENTSCOPE
		-- currently only using it for indent text object motions like 'vii' 'dai'
		require("mini.indentscope").setup({
			mappings = {
				goto_top = "", -- disabling cuz dont like this functionality
				goto_bottom = "",
			},
			symbol = "",
			draw = {
				delay = 0,
				-- animation = require('mini.indentscope').gen_animation.quadratic({ duration = 150, unit = 'total' })
				animation = require("mini.indentscope").gen_animation.none(),
			},
		})

		-- MINI.PAIRS
		-- NOTE: chose to use nvim-autopairs instead. it offers better html support
		--
		-- require("mini.pairs").setup({
		--   modes = { insert = true, command = true, terminal = false },
		--   -- skip autopair when next character is one of these
		--   skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		--   -- skip autopair when the cursor is inside these treesitter nodes
		--   -- skip_ts = { "string" },
		--   -- skip autopair when next character is closing pair
		--   -- and there are more closing pairs than opening pairs
		--   skip_unbalanced = true,
		-- })
	end,
}
