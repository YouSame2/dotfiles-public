local vscode = require("vscode")

-- Tab Navigation (VSCode tabs are editor groups)
vim.keymap.set("n", "<S-l>", function()
	vscode.action("workbench.action.nextEditorInGroup")
end, { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", function()
	vscode.action("workbench.action.previousEditorInGroup")
end, { desc = "Previous buffer" })
vim.keymap.set("n", "<C-w>O", function()
	vscode.action("workbench.action.closeOtherEditors")
end, { desc = "Close all other editor windows in VSCode" })

vim.keymap.set("n", "<leader>ut", function()
	vscode.action("workbench.action.terminal.toggleTerminal")
end, { desc = "Toggle integrated terminal" })
vim.keymap.set("n", "<leader>e", function()
	vscode.action("workbench.action.toggleSidebarVisibility")
end, { desc = "Toggle Sidebar (Explorer, Git, etc.)" })
vim.keymap.set("n", "<leader>aa", function()
	vscode.action("workbench.action.toggleAuxiliaryBar")
end, { desc = "Toggle Sidebar (Explorer, Git, etc.)" })

-- LSP
vim.keymap.set("n", "gd", function()
	vscode.action("editor.action.revealDefinition")
end, { desc = "Go to Definition" })
vim.keymap.set("n", "gD", function()
	vscode.action("editor.action.revealDeclaration")
end, { desc = "Go to Declaration" })
vim.keymap.set("n", "gi", function()
	vscode.action("editor.action.revealImplementation")
end, { desc = "Go to Implementation" })
vim.keymap.set("n", "gr", function()
	vscode.action("editor.action.findAllReferences")
end, { desc = "Find All References" })
vim.keymap.set("n", "gt", function()
	vscode.action("editor.action.goToTypeDefinition")
end, { desc = "Go to Type Definition" }) -- Overlaps with gt for tabs, consider `<leader>gt` if preferred
vim.keymap.set("n", "K", function()
	vscode.action("editor.action.showHover")
end, { desc = "Show Hover Information" })
vim.keymap.set("i", "<C-k>", function()
	vscode.action("editor.action.showSignatureHelp")
end, { desc = "Show Signature Help (Insert Mode)" })
vim.keymap.set("n", "<leader>cr", function()
	vscode.action("editor.action.rename")
end, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>ca", function()
	vscode.action("editor.action.codeAction")
end, { desc = "Show Code Actions" })

vim.keymap.set("n", "gf", function()
	vscode.action("editor.action.formatDocument")
end, { desc = "Format Document" })

-- Next/Previous problem (like Quickfix list)
vim.keymap.set("n", "]d", function()
	vscode.action("editor.action.marker.nextInFiles")
end, { desc = "Next Problem" })
vim.keymap.set("n", "[d", function()
	vscode.action("editor.action.marker.prevInFiles")
end, { desc = "Previous Problem" })

vim.keymap.set("n", "<leader>ff", function()
	vscode.action("workbench.action.quickOpen")
end, { desc = "Quick Open File" })

-- =================
-- line wrap keymaps
-- =================
vim.keymap.set("n", "j", "gj", { remap = true, desc = "cursor N lines downward (include 'wrap')" })
vim.keymap.set("n", "k", "gk", { remap = true, desc = "cursor N lines up (include 'wrap')" })
vim.keymap.set({ "n", "o", "x" }, "0", "g0", { remap = true, desc = "first char of the line (include 'wrap')" })
vim.keymap.set({ "n", "o", "x" }, "$", "g$", { remap = true, desc = "end of the line (include 'wrap')" })
vim.keymap.set("n", "A", "g$a", { remap = true, desc = "A (include 'wrap')" }) -- vscode handles this differently (broken)
vim.keymap.set("n", "I", "g0i", { remap = true, desc = "i (include 'wrap')" }) -- vscode handles this differently
---------------
-- NOTE: below changes behavior of Y,D,C to respect line wrap. comment out to have normal behavior. keep in mind you can still achive the same normal behavior just by double tapping. i.e. 'yy' or 'dd'
vim.keymap.set(
	{ "n", "o", "x", "v" },
	"^",
	"g^",
	{ remap = true, desc = "first non-blank character of the line (include 'wrap')" }
)
---------------
vim.keymap.set("n", "D", "dg$", { remap = true, desc = "[D]elete to end of line (include 'wrap')" })
vim.keymap.set("n", "C", "cg$", { remap = true, desc = "[C]hange to end of line (include 'wrap')" })
vim.keymap.set("n", "Y", "yg$", { remap = true, desc = "[Y]ank to end of line (include 'wrap')" })
