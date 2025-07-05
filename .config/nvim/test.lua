    vim.g.mapleader = ' '
local t = { a = 1, b = 2, }
    local x=1+2*3
vim.g.maplocalleader = "\\"
require("anotherone")







-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("config.options")
-- require "config.autocmds"

vim.schedule(function()
        require("config.keymaps")

end)
