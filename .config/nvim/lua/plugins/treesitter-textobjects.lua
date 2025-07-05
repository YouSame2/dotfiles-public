-- credit: mostly from: github.com/josean-dev but also part from lazyvim
-- NOTE: mini.ai suppossedly will conflict with textobjects, if using mini.ai either disable or double check keymaps.
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	event = "VeryLazy",

	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						-- ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
						-- ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
						-- ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
						-- ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

						-- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
						-- ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
						-- ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
						-- ["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
						-- ["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },

						-- ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
						-- ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

						-- ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
						-- ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

						-- ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
						-- ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

						-- ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
						-- ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

						-- ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
						-- ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

						-- ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
						-- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
					},
				},
				-- swap = {
				--   enable = true,
				--   swap_next = {
				--     ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
				--     ["<leader>n:"] = "@property.outer", -- swap object property with next
				--     ["<leader>nm"] = "@function.outer", -- swap function with next
				--   },
				--   swap_previous = {
				--     ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
				--     ["<leader>p:"] = "@property.outer", -- swap object property with prev
				--     ["<leader>pm"] = "@function.outer", -- swap function with previous
				--   },
				-- },
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = { query = "@function.outer", desc = "Next function start" },
						["]c"] = { query = "@class.outer", desc = "Next class start" },
						["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
						["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
						["]l"] = { query = "@loop.outer", desc = "Next loop start" },
						["]m"] = { query = "@call.outer", desc = "Next method start" },

						-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
						-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
						-- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						-- ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]F"] = { query = "@function.outer", desc = "Next function end" },
						["]C"] = { query = "@class.outer", desc = "Next class end" },
						["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
						["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
						["]L"] = { query = "@loop.outer", desc = "Next loop end" },
						["]M"] = { query = "@call.outer", desc = "Next method end" },
					},
					goto_previous_start = {
						["[f"] = { query = "@function.outer", desc = "Prev function start" },
						["[c"] = { query = "@class.outer", desc = "Prev class start" },
						["[a"] = { query = "@parameter.inner", desc = "Prev argument start" },
						["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
						["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
						["[m"] = { query = "@call.outer", desc = "Prev method start" },
					},
					goto_previous_end = {
						["[F"] = { query = "@function.outer", desc = "Prev function end" },
						["[C"] = { query = "@class.outer", desc = "Prev class end" },
						["[A"] = { query = "@parameter.inner", desc = "Prev argument end" },
						["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
						["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
						["[M"] = { query = "@call.outer", desc = "Prev method end" },
					},
				},
			},
		})

		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		-- vim way: ; goes to the direction you were moving.
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

		-- NOTE: below redefines move keymaps for text objects in n mode only. it centers the screen after move. autocmd is neccesary due to TS creating buffer keymaps not global keymaps. hense `buffer = e.buf`. TS keymaps also makes keymaps for other modes so its better to leave them. ofc it would be better to refactor this but this is easier to read and understand for others.
		vim.api.nvim_create_augroup("custom_ts_move", {})
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufNew" }, {
			group = "custom_ts_move",
			callback = function(e)
				-- @function.outer
				vim.keymap.set(
					"n",
					"]f",
					"<cmd>TSTextobjectGotoNextStart @function.outer<CR>zz",
					{ buffer = e.buf, desc = "Next function start", remap = true }
				)
				vim.keymap.set(
					"n",
					"]F",
					"<cmd>TSTextobjectGotoNextEnd @function.outer<CR>zz",
					{ buffer = e.buf, desc = "Next function end", remap = true }
				)
				vim.keymap.set(
					"n",
					"[f",
					"<cmd>TSTextobjectGotoPreviousStart @function.outer<CR>zz",
					{ buffer = e.buf, desc = "Prev function start", remap = true }
				)
				vim.keymap.set(
					"n",
					"[F",
					"<cmd>TSTextobjectGotoPreviousEnd @function.outer<CR>zz",
					{ buffer = e.buf, desc = "Prev function end", remap = true }
				)
				-- @class.outer
				vim.keymap.set(
					"n",
					"]c",
					"<cmd>TSTextobjectGotoNextStart @class.outer<CR>zz",
					{ buffer = e.buf, desc = "Next class start", remap = true }
				)
				vim.keymap.set(
					"n",
					"]C",
					"<cmd>TSTextobjectGotoNextEnd @class.outer<CR>zz",
					{ buffer = e.buf, desc = "Next class end", remap = true }
				)
				vim.keymap.set(
					"n",
					"[c",
					"<cmd>TSTextobjectGotoPreviousStart @class.outer<CR>zz",
					{ buffer = e.buf, desc = "Prev class start", remap = true }
				)
				vim.keymap.set(
					"n",
					"[C",
					"<cmd>TSTextobjectGotoPreviousEnd @class.outer<CR>zz",
					{ buffer = e.buf, desc = "Prev class end", remap = true }
				)
			end,
		})
	end,
}
