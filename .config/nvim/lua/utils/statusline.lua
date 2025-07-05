-- NOTE: listen imma be honest chatgpt wrote 60% of this. im still learning neovim so dont know where half these methods came from lol

-- Hl group for active buffer name
function CreateCustomHighlight()
	-- NOTE: old colors for default theme.

	-- local line_nr_fg = vim.api.nvim_get_hl_by_name("LineNr", true).foreground
	-- local tabline_bg = vim.api.nvim_get_hl_by_name("TabLine", true).background

	-- if line_nr_fg and tabline_bg then
	-- 	vim.cmd(string.format("highlight MyActiveBuffer guifg=#%06x guibg=#%06x gui=bold", line_nr_fg, tabline_bg))
	-- end

	vim.api.nvim_set_hl(0, "MyActiveBuffer", { link = "PmenuSel" })
end

local buffer_cache = {}

-- Function to update the buffer cache
function UpdateBufferCache()
	buffer_cache = vim.tbl_filter(function(buf)
		return vim.bo[buf].buflisted and vim.api.nvim_buf_is_valid(buf) -- Check if the buffer is valid
	end, vim.api.nvim_list_bufs())
end

-- Automatically update the buffer cache on events
vim.api.nvim_create_autocmd({ "BufAdd", "BufUnload", "BufWinEnter", "BufModifiedSet" }, {
	callback = UpdateBufferCache,
})

function MyBufferline()
	local current_buf = vim.api.nvim_get_current_buf()
	local buffer_names = vim.tbl_map(function(buf)
		if not vim.api.nvim_buf_is_valid(buf) then -- Skip invalid buffers
			return nil -- Return nil for invalid buffers
		end

		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
		name = name ~= "" and name or "[No Name]"

		-- Add a dot "•" if the buffer is modified
		if vim.bo[buf].modified then
			name = name .. " •"
		end

		-- Highlight the active buffer
		if buf == current_buf then
			return "%#MyActiveBuffer#" .. name .. "%#StatuslineNC#"
		else
			return name
		end
	end, buffer_cache)

	-- Remove nil values from the buffer list (for any invalid buffers)
	buffer_names = vim.tbl_filter(function(name)
		return name ~= nil
	end, buffer_names)

	return " " .. table.concat(buffer_names, " | ")
end

function Statusline()
	local set_color_2 = "%#StatuslineNC#"
	local truncation = "%>"
	local align_right = "%="
	local fileencoding = " %{&fileencoding?&fileencoding:&encoding}"
	local fileformat = " %{&fileformat}"
	local filetype = "   %Y" -- space for truncation
	local percentage = " %p%%"

	local bufferline = MyBufferline()

	return string.format(
		"%s%s%s%s%s%s%s%s",
		set_color_2,
		bufferline,
		truncation,
		align_right,
		filetype,
		fileencoding,
		fileformat,
		percentage
	)
end

UpdateBufferCache()
CreateCustomHighlight() -- Ensure the highlight group is updated dynamically
if not vim.g.vscode then
	vim.opt.statusline = "%!v:lua.Statusline()"
end
