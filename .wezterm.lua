local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- https://zenn.dev/yuys13/articles/wezterm-settings-trivia
config.use_ime = true

-- カラースキームの設定
-- Light --
-- config.color_scheme = "Homebrew Light (Gogh)"
-- Dark --
config.color_scheme = "Tomorrow Night Eighties (Gogh)"
-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "AdventureTime"
-- config.color_scheme = "Chalk (dark) (terminal.sexy)"
-- 背景透過
config.window_background_opacity = 0.95

config.macos_window_background_blur = 20
-- フォントサイズの設定
config.font_size = 20

config.font = wezterm.font_with_fallback({
	{ family = "JetBrains Mono", weight = "Medium" },
	{ family = "Terminus", weight = "Bold" },
	"ヒラギノ角ゴシック",
	"Noto Color Emoji",
})

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	-- font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font = wezterm.font_with_fallback({
		{ family = "JetBrains Mono", weight = "Medium" },
		{ family = "Terminus", weight = "Bold" },
		"ヒラギノ角ゴシック",
		"Noto Color Emoji",
	}),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 16.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#333333",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#333333",

	border_left_width = "0.25cell",
	border_right_width = "0.25cell",
	border_bottom_height = "0.25cell",
	border_top_height = "0.25cell",
	border_left_color = "purple",
	border_right_color = "purple",
	border_bottom_color = "purple",
	border_top_color = "purple",
}

config.colors = {
	cursor_border = "#52ad70",

	-- the foreground color of selected text
	selection_fg = "black",
	-- the background color of selected text
	selection_bg = "#fffacd",

	-- The color of the scrollbar "thumb"; the portion that represents the current viewport
	scrollbar_thumb = "#222222",

	-- The color of the split lines between panes
	split = "#444444",
	-- The default text color
	foreground = "silver",
	-- The default background color
	background = "black",
	tab_bar = {
		-- The color of the inactive tab bar edge/divider
		inactive_tab_edge = "#575757",
	},
}

-- ショートカットキー設定
local act = wezterm.action
config.keys = {
	{
		key = "=",
		mods = "CTRL",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "CTRL",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = ";",
		mods = "CTRL",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "'",
		mods = "CTRL",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "/",
		mods = "CTRL",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "[",
		mods = "CTRL",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = ";",
		mods = "SUPER", -- "SUPER"は通常右CMDキーに対応
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "'",
		mods = "SUPER", -- "SUPER"は通常右CMDキーに対応
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "[",
		mods = "SUPER", -- "SUPER"は通常右CMDキーに対応
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "/",
		mods = "SUPER", -- "SUPER"は通常右CMDキーに対応
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	-- Alt(Opt)+Shift+Fでフルスクリーン切り替え
	{
		key = "f",
		mods = "SHIFT|META",
		action = wezterm.action.ToggleFullScreen,
	},
	-- Ctrl+Shift+tで新しいタブを作成
	{
		key = "t",
		mods = "SHIFT|CTRL",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- Ctrl+Shift+dで新しいペインを作成(画面を分割)
	{
		key = "d",
		mods = "SHIFT|CTRL",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Split panes with alt+shift+(-|+)
	{
		key = "-",
		mods = "SHIFT|ALT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "=",
		mods = "SHIFT|ALT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
}

return config
