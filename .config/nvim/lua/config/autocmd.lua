-- ===========================
--          AUTO CMDS
-- ===========================

local function augroup(name)
	return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		(vim.hl or vim.highlight).on_yank()
	end,
})

-- dont insert comment when addint new line above comment
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup("set_format_opts"),
	callback = function()
		vim.opt.formatoptions:remove("o")
	end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit", "neo-tree" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
			vim.api.nvim_feedkeys("zz", "m", false) -- 'zz' is remapped by GoUp plugin. 'm' allows remaps
		end
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- -- Auto create dir when saving a file, in case some intermediate directory does not exist
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   group = augroup("auto_create_dir"),
--   callback = function(event)
--     if event.match:match("^%w%w+:[\\/][\\/]") then
--       return
--     end
--     local file = vim.uv.fs_realpath(event.match) or event.match
--     vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
--   end,
-- })

-- Auto-insert mode when entering terminal buffer
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup("term-auto-insert"),
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.cmd("startinsert!")
		end
	end,
})

-- HACK: IMPORTANT this will save you days of pain. i spent a day trying to figure out how to get venvs to automatically activate in python files. without it venv library imports do not properly function. this will automatically detect venvs and fix the stupid import problem for venv libraries. no need for plugin, no need to activate venv everytime. enjoy!

-- Set pythonPath when Pyright attaches to a buffer, for venv packages to work properly
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("venv-python-path"),
	callback = function(args)
		if vim.g.my_pythonPath then
			return
		end

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name == "pyright" then
			-- get Git root directory
			local function get_git_root()
				local dot_git_path = vim.fn.finddir(".git", ".;")
				if dot_git_path == "" then
					return nil
				end
				return vim.fn.fnamemodify(dot_git_path, ":h")
			end

			-- detect the virtual environment path
			local function detect_venv_path()
				local is_windows = vim.loop.os_uname().version:match("Windows")
				local python_file = is_windows and "Scripts/python" or "bin/python"
				local candidates = { ".venv", "venv", "env" }
				local git_root = get_git_root()

				if git_root then
					for _, name in ipairs(candidates) do
						local python = git_root .. "/" .. name .. "/" .. python_file
						if vim.fn.executable(python) == 1 then
							vim.schedule(function()
								vim.notify("Python venv found. Set LSP pythonPath as:\n" .. python)
							end)
							return python
						end
					end
				end

				-- Fallback: relative to whatever root Pyright picks up, if not found global python will be used
				local fallback = ".venv/" .. python_file
				vim.schedule(function()
					vim.notify("Python venv NOT found. fallback to default venv pythonPath: " .. fallback)
				end)
				return fallback
			end

			-- set pythonPath in lsp
			local python_path = detect_venv_path()
			client.config.settings.python.pythonPath = python_path
			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
			vim.g.my_pythonPath = true
		end
	end,
})

-- ===========================
--          USER CMDS
-- ===========================

-- my rapper function ;P fyi it goes together with my keymaps.lua
local function ToggleRap()
	-- set notification
	local ok, fidget = pcall(require, "fidget")
	if ok then
		vim.notify = fidget.notify
	end

	---@diagnostic disable-next-line: undefined-field
	local wrap = vim.opt_global.wrap:get()
	local cur_win_nr = vim.fn.winnr()

	if wrap then
		-- toggle wrap off and keymaps
		vim.cmd("set nowrap nolinebreak formatoptions+=l") -- set for future buffers
		vim.cmd("windo set nowrap nolinebreak formatoptions+=l") -- set for cur windo
		vim.cmd(cur_win_nr .. "wincmd w")
		vim.notify("❌ Rap disabled")
	else
		-- toggle wrap on & keymaps
		vim.cmd("set wrap linebreak formatoptions-=l")
		vim.cmd("windo set wrap linebreak formatoptions-=l")
		vim.cmd(cur_win_nr .. "wincmd w")
		vim.notify("✅ Rap enabled")
	end
end

vim.api.nvim_create_user_command("ToggleRap", ToggleRap, { desc = "Toggle wrap and keymaps" })
vim.keymap.set("n", "<leader>uw", "<cmd>ToggleRap<CR>", { desc = "[u]i toggle line [w]rap and movement" })

-- redir output of cmd to scratch buffer. cred: (https://www.reddit.com/r/neovim/comments/zhweuc/whats_a_fast_way_to_load_the_output_of_a_command/)
vim.api.nvim_create_user_command("Redir", function(ctx)
	local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
	vim.cmd("vnew")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.opt_local.modified = false
end, { nargs = "+", complete = "command" })
