local git_hunks = function()
	local Job = require("plenary.job")
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local sorters = require("telescope.sorters")
	local conf = require("telescope.config").values

	local function collect_diff_lines(callback)
		local results = {}

		-- Collect diff from tracked files
		Job:new({
			command = "git",
			args = { "diff", "--no-prefix", "--relative" },
			on_exit = function(j)
				for _, line in ipairs(j:result()) do
					table.insert(results, line)
				end

				-- Collect untracked files
				Job:new({
					command = "git",
					args = { "ls-files", "--others", "--exclude-standard" },
					on_exit = function(untracked_job)
						local untracked_files = untracked_job:result()
						local pending = #untracked_files
						if pending == 0 then
							callback(results)
							return
						end

						for _, file in ipairs(untracked_files) do
							-- Diff against /dev/null
							Job:new({
								command = "git",
								args = { "diff", "--no-index", "--no-prefix", "--relative", "/dev/null", file },
								on_exit = function(diff_job)
									vim.schedule(function()
										for _, line in ipairs(diff_job:result()) do
											table.insert(results, line)
										end
										pending = pending - 1
										if pending == 0 then
											callback(results)
										end
									end)
								end,
							}):start()
						end
					end,
				}):start()
			end,
		}):start()
	end

	local function parse_diff_lines(lines)
		local entries = {}
		local current_file = nil
		local current_line = nil

		for _, line in ipairs(lines) do
			local new_file = line:match("^%+%+%+ (.+)")
			if new_file then
				current_file = new_file ~= "/dev/null" and new_file or nil
			end

			local hunk_line = line:match("^@@ .*%+([0-9]+)")
			if hunk_line then
				current_line = tonumber(hunk_line)
			elseif current_file and current_line and (line:match("^%+") or line:match("^%-")) then
				local content = line:sub(2)
				table.insert(entries, {
					value = current_file,
					display = string.format("%s:%d:1: %s", current_file, current_line, content),
					ordinal = string.format("%s:%d", current_file, current_line),
					filename = current_file,
					lnum = current_line,
				})
				current_line = nil
			elseif line:match("^ ") and current_line then
				current_line = current_line + 1
			end
		end

		return entries
	end

	collect_diff_lines(function(lines)
		local entries = parse_diff_lines(lines)

		pickers
			.new({}, {
				prompt_title = "Git hunks",
				results_title = "Git hunks",
				finder = finders.new_table({
					results = entries,
					entry_maker = function(entry)
						return entry
					end,
				}),
				sorter = sorters.get_generic_fuzzy_sorter(),
				previewer = conf.grep_previewer({}),
				layout_strategy = "flex",
			})
			:find()
	end)
end

vim.keymap.set("n", "<Leader>ggh", git_hunks, {})

-- OS SPECIFIC OPTS:
-- =================
local os_name = vim.loop.os_uname().sysname
if os_name == "Windows_NT" then
	vim.o.shelltemp = false -- prefer piping rather than temp files in shell commands (i.e. :%!sort) windows sometimes cant read the temp files, in that case use shellpipe opt below
	vim.opt.shell = "bash" -- use bashshell (gitbash)
	vim.opt.shellcmdflag = "-c" -- equal to bash.exe -c
	vim.opt.shellxquote = "" -- wrap shell cmd's in nothing
	-- vim.opt.shellslash = true -- breaks telescope help_tags. originally used because im using gitbash in windows. but dont think i need it.
	vim.opt.shellpipe = '2>&1| tee "%s"' -- fixes cant write to temp files when spaces are in windows username. noticiable when using !grep

	-- NOT RECOMMENDED just for reference in case slow nvim
	-- vim.g.nofsync = true
end

-- OPTIONS:
-- =================

-- editing
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.virtualedit = "block" -- idk bout this one but just incase

vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.shiftround = true -- Round indent
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.backspace = { "start", "eol", "indent" }

vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true

vim.opt.jumpoptions = "clean,stack"

-- these 2 dont work cuz ft sets it on bufenter so i setup autocmd
-- vim.cmd("set formatoptions-=o") -- -o = 'o'/'O' dont add comment
-- vim.cmd("set formatoptions-=l") --  -l break existing long lines

-- appearance
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true -- True color support
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- from help example

vim.api.nvim_set_hl(0, "WinSeparator", { link = "Conceal" }) -- change color of pane separators
vim.opt.laststatus = 3 -- only 1 global statusline. dont forget fillchars
vim.opt.fillchars = {
	horiz = "━",
	horizup = "┻",
	horizdown = "┳",
	vert = "┃",
	vertleft = "┫",
	vertright = "┣",
	verthoriz = "╋",
	eob = " ",
}

-- CUSTOM STATUSLINE:
-- =================
-- local function statusline()
--   -- local file_name = " %f"
--   local set_color_2 = "%#TabLine#"
--   local modified = "%m"
--   local align_right = "%="
--   local fileencoding = " %{&fileencoding?&fileencoding:&encoding}"
--   local fileformat = " %{&fileformat}"
--   local filetype = " %Y"
--   local percentage = " %p%%"

--   return string.format(
--     "%s%s%s%s%s%s%s",
--     set_color_2,
--     align_right,
--     modified,
--     filetype,
--     fileencoding,
--     fileformat,
--     percentage
--   )
-- end

vim.cmd.colorscheme("Retrobox") -- loved default but after some time relized having good theme really helps quickly understanding code flow...
vim.api.nvim_set_hl(0, "LineNr", { link = "Identifier" })
vim.api.nvim_set_hl(0, "LineNrAbove", { link = "Comment" })
vim.api.nvim_set_hl(0, "LineNrBelow", { link = "Comment" })
-- old ones used for default colorscheme
-- vim.api.nvim_set_hl(0, "LineNr", { fg = "NvimLightBlue" })
-- vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "NvimLightGray3" })
-- vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "NvimLightGray3" })
-- vim.opt.statusline = statusline() -- old version
require("utils/statusline")

-- better diff highlighting (credit: https://www.reddit.com/r/neovim/comments/1k3ugsd/improving_the_vimdiff_highlighting_globally_for/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button)
local function set_diff_highlights()
	local is_dark = vim.o.background == "dark"
	if is_dark then
		vim.api.nvim_set_hl(0, "DiffAdd", { fg = "none", bg = "#2e4b2e", bold = true })
		vim.api.nvim_set_hl(0, "DiffDelete", { fg = "none", bg = "#4c1e15", bold = true })
		vim.api.nvim_set_hl(0, "DiffChange", { fg = "none", bg = "#45565c", bold = true })
		vim.api.nvim_set_hl(0, "DiffText", { fg = "none", bg = "#5a3f43", bold = true })
	else
		vim.api.nvim_set_hl(0, "DiffAdd", { fg = "none", bg = "palegreen", bold = true })
		vim.api.nvim_set_hl(0, "DiffDelete", { fg = "none", bg = "tomato", bold = true })
		vim.api.nvim_set_hl(0, "DiffChange", { fg = "none", bg = "lightblue", bold = true })
		vim.api.nvim_set_hl(0, "DiffText", { fg = "none", bg = "lightpink", bold = true })
	end
end
set_diff_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("my_diff_colors", { clear = true }),
	callback = set_diff_highlights,
})

-- transparency settings
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.diagnostic.config({ float = { border = "rounded" } })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})
