local wezterm = require 'wezterm'
local color = require 'colors'
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
---@diagnostic disable-next-line: unused-local
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.automatically_reload_config = true
local color_scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
color_scheme.tab_bar.active_tab.bg_color = color.blue
color_scheme.tab_bar.active_tab.intensity = "Bold"
color_scheme.cursor_bg = color.text
color_scheme.cursor_fg = color.crust
color_scheme.cursor_border = color.text

config.color_schemes = { ["Catppuccin"] = color_scheme }
config.color_scheme = "Catppuccin"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {left = 0, right = 0, top = 0, bottom = 0,}
config.status_update_interval = 1000

wezterm.on("update-status", function(window)
	local stat = window:active_workspace()
	local stat_fg = color.crust
	local stat_bg = color.blue

	if window:active_key_table() then
		stat = window:active_key_table()
		stat_bg = color.mauve
	end
	if window:leader_is_active() then
		stat = "leader"
		stat_bg = color.green
	end

	local max_len = 8
	local padding = ""
	if stat == "search_mode" then stat = "search" end
	if stat == "copy_mode" then stat = "drift" end
	if #stat > max_len then
		stat = stat:sub(1, max_len)
	else
		padding = string.rep(" ", max_len - #stat)
	end

	window:set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = stat_fg } },
		{ Background = { Color = stat_bg } },
		{ Text = " " .. padding },
		{ Text = stat .. " " .. wezterm.nerdfonts.oct_table .. " " },
		{ Text = " " },
	}))
end)

config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", scale = 1.05, weight = "Medium" },
})

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.8,
}

config.window_decorations = "RESIZE"

config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{ key = "s", mods = "LEADER|CTRL", action = act.SendKey({ key = "s", mods = "CTRL" }) },
	{ key = "f", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "a", mods = "LEADER", action = act.PaneSelect({mode = "Activate"})},
	{ key = "d", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	{ key = "n", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "H", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "L", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "t", mods = "LEADER", action = act.ShowTabNavigator },

	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
	{ key = "Backspace", mods = "CTRL", action = wezterm.action.SendKey({ key = "w", mods = "CTRL" }) },

	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "resize", one_shot = false }),
	},
	{
	  key = "m",
	  mods = "LEADER",
	  action = act.ActivateKeyTable({ name = "move", one_shot = false })
	},
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	search = {
		{ key = "Escape", action = act.CopyMode("Close") },
		{ key = "i", action = act.CopyMode("Close") },
		{ key = "Enter", action = act.CopyMode("NextMatch") },
		{ key = "Enter", mods = "SHIFT", action = act.CopyMode("PriorMatch") },
		{ key = "l", mods = "CTRL", action = act.CopyMode("ClearPattern") },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
		{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
		{
			key = "u",
			mods = "CTRL",
			action = act.CopyMode("PriorMatchPage"),
		},
		{
			key = "d",
			mods = "CTRL",
			action = act.CopyMode("NextMatchPage"),
		},
	},
}

return config
