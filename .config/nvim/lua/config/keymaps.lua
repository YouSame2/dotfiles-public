-- =================
-- general keymaps
-- =================
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected line up" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "move line up keep cursor position" })
vim.keymap.set("v", "<", "<gv", { desc = "indent left keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "indent right keep selection" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "next Buffer" })
vim.keymap.set(
	"n",
	"<leader>fs",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[f]ind and [r]eplace" }
)
vim.keymap.set("n", "<C-w>O", function()
	local curr_buf = vim.api.nvim_get_current_buf()
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in ipairs(buffers) do
		if buf ~= curr_buf and vim.api.nvim_buf_is_valid(buf) then
			vim.cmd("silent! bdelete " .. buf)
		end
	end
end, { desc = "delete all unmodified buffers" })

vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Increment/decrement and toggle boolean
vim.keymap.set("n", "-", function()
	local word = vim.fn.expand("<cword>")
	if word == "true" then
		vim.cmd("normal! ciwfalseb")
	elseif word == "false" then
		vim.cmd("normal! ciwtrueb")
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-x>", true, true, true), "n", false)
	end
end, { desc = "decrement or toggle bool" })
vim.keymap.set("n", "+", function()
	local word = vim.fn.expand("<cword>")
	if word == "true" then
		vim.cmd("normal! ciwfalseb")
	elseif word == "false" then
		vim.cmd("normal! ciwtrueb")
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-a>", true, true, true), "n", false)
	end
end, { desc = "increment or toggle bool" })

-- =================
-- ui keymaps
-- =================
vim.keymap.set({ "n", "s" }, "<esc>", function()
	vim.cmd("noh")
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })
vim.keymap.set("n", "<leader>ul", function()
	local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "toggle [u]i [l]ocation list" })
vim.keymap.set("n", "<leader>uq", function()
	local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "toggle [u]i [q]uickfix list" })
local diagnostics_visible = {}
vim.keymap.set("n", "<leader>ud", function()
	local bufnr = vim.api.nvim_get_current_buf()
	if diagnostics_visible[bufnr] == nil then
		diagnostics_visible[bufnr] = false
	else
		diagnostics_visible[bufnr] = not diagnostics_visible[bufnr]
	end
	if diagnostics_visible[bufnr] then
		vim.diagnostic.show(nil, bufnr)
	else
		vim.diagnostic.hide(nil, bufnr)
	end
end, { desc = "[u]i toggle [d]iagnostic <buffer>" })

-- =================
-- centering keymaps
-- =================
-- i use a plugin called Go-Up (BEST PLUGIN EVER!) which remaps 'zz'
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected line down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "half page up & center", remap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "half page down & center", remap = true })
vim.keymap.set(
	"n",
	"]d",
	"<cmd>lua vim.diagnostic.goto_next()<CR>zz",
	{ desc = "next diagnostic & center", remap = true }
)
vim.keymap.set(
	"n",
	"[d",
	"<cmd>lua vim.diagnostic.goto_prev()<CR>zz",
	{ desc = "prev diagnostic & center", remap = true }
)
vim.keymap.set("n", "}", "}zz", { desc = "next paragraph & center", remap = true })
vim.keymap.set("n", "{", "{zz", { desc = "previous paragraph & center", remap = true })
vim.keymap.set("n", "n", "nzzzv", { desc = "search next & center", remap = true })
vim.keymap.set("n", "N", "Nzzzv", { desc = "search prev & center", remap = true })
vim.keymap.set("n", "'", function()
	return "'" .. vim.fn.nr2char(vim.fn.getchar()) .. "zz"
end, { remap = true, expr = true, desc = "goto mark & center" })
vim.keymap.set("n", "`", function()
	return "`" .. vim.fn.nr2char(vim.fn.getchar()) .. "zz"
end, { remap = true, expr = true, desc = "goto mark & center" })
-- using trouble, see ../plugins/trouble.lua
-- vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous Quickfix", remap = true })
-- vim.keymap.set("n", "[Q", "<cmd>cfir<CR>zz", { desc = "Previous Quickfix", remap = true })
-- vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next Quickfix", remap = true })
-- vim.keymap.set("n", "]Q", "<cmd>cla<CR>zz", { desc = "Next Quickfix", remap = true })

-- =================
-- better copy, paste, yank
-- =================
-- recommend using these copy/paste rather than terminals, there better. :D
vim.keymap.set("v", "y", "mzy`z", { desc = "y selection, keep cursor position" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "P over selection keep p reg" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "d over selection keep p reg" })
vim.keymap.set({ "n", "v" }, "<leader>D", '"_D', { desc = "D over selection keep p reg" })
vim.keymap.set({ "v" }, "<C-S-c>", [[mz"+y`z]], { desc = "y to system cb, keep cursor position" })
vim.keymap.set({ "!", "t" }, "<C-S-c>", [["+y]], { desc = "y to system cb" })
vim.keymap.set("n", "<C-S-c><C-S-c>", [["+Y]], { desc = "yy to system cb" })
vim.keymap.set("n", "<C-S-c>", [["+y]], { desc = "Y to system cb" })
vim.keymap.set({ "n", "v" }, "<C-S-v>", [["+p]], { desc = "p from system cb" })
vim.keymap.set({ "!", "t" }, "<C-S-v>", [[<C-r>+]], { desc = "p from system cb" })
vim.keymap.set({ "v" }, "<leader><C-S-v>", [["_d"+P]], { desc = "P from system cb over selection, keep p reg" })

vim.keymap.set("n", "gco", 'o<esc>V"_cx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = "Add Comment Below" })
vim.keymap.set("n", "gcO", 'O<esc>V"_cx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = "Add Comment Above" })

-- =================
-- line wrap keymaps
-- =================
if not vim.g.vscode then -- vscode is werid...
	vim.keymap.set(
		"n",
		"j",
		"v:count == 0 ? 'gj' : 'j'",
		{ expr = true, desc = "cursor N lines downward (include 'wrap')" }
	)
	vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "cursor N lines up (include 'wrap')" })
	vim.keymap.set("n", "0", "g0", { desc = "first char of the line (include 'wrap')" })
	vim.keymap.set("n", "^", "g^", { desc = "first non-blank character of the line (include 'wrap')" })
	vim.keymap.set("n", "$", "g$", { desc = "end of the line (include 'wrap')" })
	vim.keymap.set("n", "I", "g^i", { remap = true, desc = "I (include 'wrap')" })
	vim.keymap.set("n", "A", "g$a", { remap = true, desc = "A (include 'wrap')" })
	---------------
	-- NOTE: below changes behavior of Y,D,C to respect line wrap. comment out to have normal behavior. keep in mind you can still achive the same normal behavior just by double tapping. i.e. 'yy' or 'dd'
	vim.keymap.set(
		"n",
		"D",
		"v:count == 0 ? 'dg$' : 'D'",
		{ expr = true, desc = "[D]elete to end of line (include 'wrap')" }
	)
	vim.keymap.set(
		"n",
		"C",
		"v:count == 0 ? 'cg$' : 'C'",
		{ expr = true, desc = "[C]hange to end of line (include 'wrap')" }
	)
	vim.keymap.set(
		"n",
		"Y",
		"v:count == 0 ? 'yg$' : 'y$'",
		{ expr = true, desc = "[Y]ank to end of line (include 'wrap')" }
	)
	---------------
	vim.keymap.set(
		"v",
		"j",
		"v:count == 0 ? 'gj' : 'j'",
		{ expr = true, desc = "cursor N lines downward (include 'wrap')" }
	)
	vim.keymap.set("v", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "cursor N lines up (include 'wrap')" })
	vim.keymap.set("v", "0", "g0", { desc = "first char of the line (include 'wrap')" })
	vim.keymap.set("v", "^", "g^", { desc = "first non-blank character of the line (include 'wrap')" })
	vim.keymap.set("v", "$", "g$", { desc = "end of the line (include 'wrap')" })
end

-- =================
-- Terminal Mappings
-- =================

-- Exit terminal mode
-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<C-w><C-w>", "<C-\\><C-n>:wincmd w<CR>", { silent = true, desc = "Switch window (terminal mode)" })
vim.keymap.set(
	"t",
	"<C-w>h",
	"<C-\\><C-n>:wincmd h<CR>",
	{ silent = true, desc = "Switch window left (terminal mode)" }
)
vim.keymap.set(
	"t",
	"<C-w>l",
	"<C-\\><C-n>:wincmd l<CR>",
	{ silent = true, desc = "Switch window right (terminal mode)" }
)
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n>:wincmd k<CR>", { silent = true, desc = "Switch window up (terminal mode)" })
vim.keymap.set(
	"t",
	"<C-w>j",
	"<C-\\><C-n>:wincmd j<CR>",
	{ silent = true, desc = "Switch window down (terminal mode)" }
)
