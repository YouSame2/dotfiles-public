return {
	s({ trig = "--", desc = "Multiline comment" }, { -- idk why but --[[ just doesnt work as trigger
		t({ "--[[", "" }),
		i(0),
		t({ "", "--]]" }),
	}),

	s({ trig = "vim.keymap.set", desc = "vim.keymap.set" }, {
		t("vim.keymap.set('"),
		i(1, "n"),
		t("', '<leader>"),
		-- Tabstop 2: LHS (Left-hand side key)
		i(2, "lhs"),
		t("', '"),
		-- Tabstop 3: RHS (Right-hand side action - command string or function)
		i(3, "rhs"),
		-- Optional Tabstop 4: Options table. Includes the preceding comma.
		t("', { desc = '"),
		i(4, "Mapping description"),
		t("'"),
		-- Final cursor position
		i(0),
		t(" })"),
	}),
}
