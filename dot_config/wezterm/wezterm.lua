local wezterm = require("wezterm")

-- 1. Load Pywal Colors
-- Ensure you have created the template at ~/.config/wal/templates/colors-wezterm.lua
-- and ran 'wal -i /path/to/image' at least once.
local wal_file = os.getenv("HOME") .. "/.cache/wal/colors-wezterm.lua"
local colors = dofile(wal_file)

-- NOTE: I removed the "gui-startup" fullscreen code.
-- Now the window will open normally, and Linux Mint should remember its position better.

return {
	-- Set NuShell as default
	default_prog = { "nu" },

	-- Thin Cursor
	default_cursor_style = "BlinkingBar",

	-- 2. Apply Pywal Colors
	-- This replaces the hardcoded Everforest table
	colors = colors,

	-- Window Look
	window_background_opacity = 0.80,
	text_background_opacity = 1.00,
	window_padding = { left = 5, right = 5, top = 5, bottom = 5 },

	-- Font
	font = wezterm.font("DankMono Nerd Font", { weight = "ExtraBold", italic = true }),
	font_size = 22,

	-- Tab Bar
	enable_tab_bar = false,
	-- Initial Window Size
	initial_cols = 118,
	initial_rows = 29,

	-- System Integration
	enable_kitty_keyboard = true,
}
