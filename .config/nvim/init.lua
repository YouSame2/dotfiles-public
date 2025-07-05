vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.options")
require("config.autocmd")
-- require "config.autocmds"

vim.schedule(function()
	require("config.keymaps")
	if vim.g.vscode then
		require("config.vscode")
	end
end)

-- function fix_telescope_parens_win()
-- 	if vim.fn.has("win32") then
-- 		local ori_fnameescape = vim.fn.fnameescape
-- 		---@diagnostic disable-next-line: duplicate-set-field
-- 		vim.fn.fnameescape = function(...)
-- 			local result = ori_fnameescape(...)
-- 			return result:gsub("\\", "/")
-- 		end
-- 	end
--   print("ran fix_telescope_parens_win")
-- end
--
-- fix_telescope_parens_win()
