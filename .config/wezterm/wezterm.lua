-- https://github.com/mplusp/dotfiles/tree/main -- good resource
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("Hurmit Nerd Font Mono", { weight = "DemiBold" })
config.font_size = 13
-- config.line_height = 1.1

-- sorted fav to least fav
local themes = {
	"Sex Colors (terminal.sexy)", -- obviously
	"synthwave",
	"Argonaut (Gogh)",
	"One Half Black (Gogh)",
	"NvimDark",
	"Orangish (terminal.sexy)",
	"Gruvbox Material (Gogh)",
	"Raycast_Dark",
	"Tokyo Night",
}
config.color_scheme = themes[3]
config.colors = {
	-- not being able to see search hl drives me nuts
	copy_mode_inactive_highlight_bg = { Color = "#394b70" },
	copy_mode_inactive_highlight_fg = { AnsiColor = "White" },
	selection_bg = "#c0caf5",
	selection_fg = "#1f2335",

	-- reset cursor colors
	cursor_bg = "#c0caf5",
	cursor_border = "#c0caf5",
	cursor_fg = "#1a1b26",
	compose_cursor = "#ff9e64",
	-- better background
	background = "#000000",
}

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

config.window_background_opacity = 0.90
config.macos_window_background_blur = 10

config.front_end = "WebGpu" -- breaks transparency on win
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 60
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 60
config.cursor_blink_rate = 500

-- ===========================
-- WINDOWS SPECIFIC SETTINGS
-- ===========================
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.font_size = 10

	-- LEGACY use powershell (for win 11 i think its 'pwsh.exe')
	-- config.default_prog = { 'powershell.exe' }

	-- Use Git Bash
	config.front_end = "OpenGL"
	config.default_prog = { "C:/Program Files/Git/bin/bash.exe", "--login" }
	config.max_fps = 144
	config.animation_fps = 144

	-- wasnt working for me
	-- Possible values = Auto | Disable | Acrylic | Mica | Tabbed
	-- config.win32_system_backdrop = 'Acrylic'
end

-- ===========================
--       KEYBINDINGS
-- ===========================

config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
local act = wezterm.action

-- creates keymap that dont work in any fullscreen TUI (i.e. nvim, yazi)
function TermOnlyKey(key, mods, action)
	local keybind = {}
	keybind.key = key
	keybind.mods = mods
	keybind.action = wezterm.action_callback(function(window, pane)
		if pane:is_alt_screen_active() then
			window:perform_action(act.SendKey({ key = key, mods = mods }), pane)
		else
			for _, task in ipairs(action) do
				window:perform_action(task, pane)
			end
		end
	end)
	return keybind
end

config.keys = {
	-- Term Only Keybinds
	TermOnlyKey("w", "SUPER", { act.CloseCurrentTab({ confirm = false }) }),
	TermOnlyKey("w", "LEADER", { act.CloseCurrentTab({ confirm = false }) }),
	TermOnlyKey("q", "LEADER", { act.QuitApplication }),
	TermOnlyKey("q", "SUPER", { act.QuitApplication }),

	TermOnlyKey("d", "CTRL", { act.ScrollByPage(0.5) }),
	TermOnlyKey("u", "CTRL", { act.ScrollByPage(-0.5) }),
	TermOnlyKey("PageDown", "NONE", { act.ScrollByPage(0.5) }),
	TermOnlyKey("PageUp", "NONE", { act.ScrollByPage(-0.5) }),

	TermOnlyKey("/", "CTRL", { act.Search({ CaseInSensitiveString = "" }) }),
	TermOnlyKey("x", "CTRL", { act.ActivateCopyMode }),
	TermOnlyKey("l", "CTRL|SHIFT", { act.ShowDebugOverlay }),
	TermOnlyKey("p", "CTRL|SHIFT", { act.ActivateCommandPalette }),
	TermOnlyKey(
		"k",
		"CTRL|SHIFT",
		{ act.ClearScrollback("ScrollbackAndViewport"), act.SendKey({ key = "l", mods = "CTRL" }) }
	),

	TermOnlyKey("c", "SUPER", { act.CopyTo("Clipboard"), act.ClearSelection }), -- have sep keymaps in vim for copy/paste
	TermOnlyKey("C", "SHIFT|CTRL", { act.CopyTo("Clipboard"), act.ClearSelection }),
	TermOnlyKey("Copy", "NONE", { act.CopyTo("Clipboard"), act.ClearSelection }),
	TermOnlyKey("v", "SUPER", { act.PasteFrom("Clipboard") }),
	TermOnlyKey("V", "SHIFT|CTRL", { act.PasteFrom("Clipboard") }),
	TermOnlyKey("Paste", "NONE", { act.PasteFrom("Clipboard") }),

	-- Universal Keybinds
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) }, -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A

	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "n", mods = "LEADER", action = act.SpawnWindow },
	{ key = "n", mods = "SUPER", action = act.SpawnWindow },
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "m", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "r", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

	{ key = "h", mods = "CTRL|LEADER", action = act.AdjustPaneSize({ "Left", 15 }) },
	{ key = "l", mods = "CTRL|LEADER", action = act.AdjustPaneSize({ "Right", 15 }) },
	{ key = "k", mods = "CTRL|LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "j", mods = "CTRL|LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },

	{ key = ",", mods = "LEADER", action = act.MoveTabRelative(-1) }, -- , is easier than <
	{ key = ".", mods = "LEADER", action = act.MoveTabRelative(1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "1", mods = "SUPER", action = act.ActivateTab(0) },
	{ key = "2", mods = "SUPER", action = act.ActivateTab(1) },
	{ key = "3", mods = "SUPER", action = act.ActivateTab(2) },
	{ key = "4", mods = "SUPER", action = act.ActivateTab(3) },
	{ key = "5", mods = "SUPER", action = act.ActivateTab(4) },
	{ key = "6", mods = "SUPER", action = act.ActivateTab(5) },
	{ key = "7", mods = "SUPER", action = act.ActivateTab(6) },
	{ key = "8", mods = "SUPER", action = act.ActivateTab(7) },
	{ key = "9", mods = "SUPER", action = act.ActivateTab(-1) },
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(-1) },

	{ key = "=", mods = "LEADER", action = act.IncreaseFontSize },
	{ key = "-", mods = "LEADER", action = act.DecreaseFontSize },
	{ key = "0", mods = "LEADER", action = act.ResetFontSize },
	{ key = " ", mods = "CTRL", action = wezterm.action.SendKey({ key = " ", mods = "CTRL" }) }, -- windows ctrl-space fix
	{ key = " ", mods = "CTRL|SHIFT", action = wezterm.action.SendKey({ key = " ", mods = "CTRL|SHIFT" }) }, -- windows ctrl-shift-space fix
}

-- only change desired key_table values without overridding all values
local search_mode = wezterm.gui.default_key_tables().search_mode
-- local copy_mode = wezterm.gui.default_key_tables().copy_mode
table.insert(search_mode, {
	key = "Escape",
	mods = "NONE",
	action = act.Multiple({ act.CopyMode("ClearPattern"), act.CopyMode("Close") }), -- really wezterm? why not clear my search by default?
})
config.key_tables = {
	search_mode = search_mode,
	-- copy_mode = copy_mode,
}

-- -- default key_tables for reference
-- config.key_tables = {
--   copy_mode = {
--     { key = "Tab",    mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
--     { key = "Tab",    mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
--     { key = "Enter",  mods = "NONE",  action = act.CopyMode("MoveToStartOfNextLine") },
--     { key = "Escape", mods = "NONE",  action = act.CopyMode("Close") },
--     { key = "Space",  mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Cell" }) },
--     { key = "$",      mods = "NONE",  action = act.CopyMode("MoveToEndOfLineContent") },
--     { key = "$",      mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
--     { key = ",",      mods = "NONE",  action = act.CopyMode("JumpReverse") },
--     { key = "0",      mods = "NONE",  action = act.CopyMode("MoveToStartOfLine") },
--     { key = ";",      mods = "NONE",  action = act.CopyMode("JumpAgain") },
--     { key = "F",      mods = "NONE",  action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
--     { key = "F",      mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
--     { key = "G",      mods = "NONE",  action = act.CopyMode("MoveToScrollbackBottom") },
--     { key = "G",      mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
--     { key = "H",      mods = "NONE",  action = act.CopyMode("MoveToViewportTop") },
--     { key = "H",      mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
--     { key = "L",      mods = "NONE",  action = act.CopyMode("MoveToViewportBottom") },
--     { key = "L",      mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
--     { key = "M",      mods = "NONE",  action = act.CopyMode("MoveToViewportMiddle") },
--     { key = "M",      mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
--     { key = "O",      mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
--     { key = "O",      mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
--     { key = "T",      mods = "NONE",  action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
--     { key = "T",      mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
--     { key = "V",      mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Line" }) },
--     { key = "V",      mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
--     { key = "^",      mods = "NONE",  action = act.CopyMode("MoveToStartOfLineContent") },
--     { key = "^",      mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
--     { key = "b",      mods = "NONE",  action = act.CopyMode("MoveBackwardWord") },
--     { key = "b",      mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },
--     { key = "b",      mods = "CTRL",  action = act.CopyMode("PageUp") },
--     { key = "c",      mods = "CTRL",  action = act.CopyMode("Close") },
--     { key = "d",      mods = "CTRL",  action = act.CopyMode({ MoveByPage = 0.5 }) },
--     { key = "e",      mods = "NONE",  action = act.CopyMode("MoveForwardWordEnd") },
--     { key = "f",      mods = "NONE",  action = act.CopyMode({ JumpForward = { prev_char = false } }) },
--     { key = "f",      mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
--     { key = "f",      mods = "CTRL",  action = act.CopyMode("PageDown") },
--     { key = "g",      mods = "NONE",  action = act.CopyMode("MoveToScrollbackTop") },
--     { key = "g",      mods = "CTRL",  action = act.CopyMode("Close") },
--     { key = "h",      mods = "NONE",  action = act.CopyMode("MoveLeft") },
--     { key = "j",      mods = "NONE",  action = act.CopyMode("MoveDown") },
--     { key = "k",      mods = "NONE",  action = act.CopyMode("MoveUp") },
--     { key = "l",      mods = "NONE",  action = act.CopyMode("MoveRight") },
--     { key = "m",      mods = "ALT",   action = act.CopyMode("MoveToStartOfLineContent") },
--     { key = "o",      mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEnd") },
--     { key = "q",      mods = "NONE",  action = act.CopyMode("Close") },
--     { key = "t",      mods = "NONE",  action = act.CopyMode({ JumpForward = { prev_char = true } }) },
--     { key = "u",      mods = "CTRL",  action = act.CopyMode({ MoveByPage = -0.5 }) },
--     { key = "v",      mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Cell" }) },
--     { key = "v",      mods = "CTRL",  action = act.CopyMode({ SetSelectionMode = "Block" }) },
--     { key = "w",      mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
--     {
--       key = "y",
--       mods = "NONE",
--       action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
--     },
--     { key = "PageUp",     mods = "NONE", action = act.CopyMode("PageUp") },
--     { key = "PageDown",   mods = "NONE", action = act.CopyMode("PageDown") },
--     { key = "End",        mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
--     { key = "Home",       mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
--     { key = "LeftArrow",  mods = "NONE", action = act.CopyMode("MoveLeft") },
--     { key = "LeftArrow",  mods = "ALT",  action = act.CopyMode("MoveBackwardWord") },
--     { key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
--     { key = "RightArrow", mods = "ALT",  action = act.CopyMode("MoveForwardWord") },
--     { key = "UpArrow",    mods = "NONE", action = act.CopyMode("MoveUp") },
--     { key = "DownArrow",  mods = "NONE", action = act.CopyMode("MoveDown") },
--   },
--   search_mode = {
--     { key = "Enter",     mods = "NONE", action = act.CopyMode("PriorMatch") },
--     { key = "Escape",    mods = "NONE", action = act.CopyMode("Close") },
--     { key = "n",         mods = "CTRL", action = act.CopyMode("NextMatch") },
--     { key = "p",         mods = "CTRL", action = act.CopyMode("PriorMatch") },
--     { key = "r",         mods = "CTRL", action = act.CopyMode("CycleMatchType") },
--     { key = "u",         mods = "CTRL", action = act.CopyMode("ClearPattern") },
--     { key = "PageUp",    mods = "NONE", action = act.CopyMode("PriorMatchPage") },
--     { key = "PageDown",  mods = "NONE", action = act.CopyMode("NextMatchPage") },
--     { key = "UpArrow",   mods = "NONE", action = act.CopyMode("PriorMatch") },
--     { key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
--   },
-- }

return config
