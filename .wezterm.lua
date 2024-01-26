local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- カラースキームの設定
config.color_scheme = "AdventureTime"
-- 背景透過
config.window_background_opacity = 0.95
-- フォントサイズの設定
config.font_size = 20

-- ショートカットキー設定
local act = wezterm.action
config.keys = {
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
}

return config
