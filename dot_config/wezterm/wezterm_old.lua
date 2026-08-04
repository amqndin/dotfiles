--- wezterm.lua
--- $ figlet -f small Wezterm
--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_|
---
--- My Wezterm config file

local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- Settings
config.automatically_reload_config = true
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", scale = 1.05, weight = "Medium" },
})
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- Dim inactive panes
-- config.inactive_pane_hsb = {
--   saturation = 0.24,
--   brightness = 0.5
-- }

-- Colors
local catppuccin = {
  base = "#1e1e2e",
  surface0 = "#313244",
  surface1 = "#45475a",
  surface2 = "#585b70",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay0 = "#9399b2",
  overlay1 = "#7f849c",
  overlay2 = "#6c7086",
  mantle = "#181825",
  crust = "#11111b",
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
}

config.colors = {
  tab_bar = {
    background = catppuccin.crust, -- dark background for tab bar

    active_tab = {
      bg_color = catppuccin.blue, -- lighter bg for active tab
      fg_color = catppuccin.crust,     -- bright text
      intensity = "Bold",
      underline = "None",
      italic = false,
      strikethrough = false,
    },

    inactive_tab = {
      bg_color = catppuccin.mantle, -- darker bg for inactive tabs
      fg_color = catppuccin.subtext0, -- dimmer text
    },

    inactive_tab_hover = {
      bg_color = catppuccin.surface1, -- slightly lighter on hover
      fg_color = catppuccin.text,
      italic = true,
    },

    new_tab = {
      bg_color = catppuccin.mantle,
      fg_color = catppuccin.subtext0,
    },

    new_tab_hover = {
      bg_color = catppuccin.surface1,
      fg_color = catppuccin.text,
      italic = true,
    },
  },
}

-- Keys
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "s", mods = "LEADER|CTRL", action = act.SendKey({ key = "s", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "l", mods = "ALT", action = act.CopyMode("Close") },
	{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "d", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
	},

	{ key = "n", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "H", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "L", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(1) },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "t", mods = "LEADER", action = act.ShowTabNavigator },
	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "m",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }),
	},
	{ key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

	{ key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }, { Regex = "" }) },

	{ key = "Backspace", mods = "CTRL", action = wezterm.action.SendKey({ key = "w", mods = "CTRL" }) },
}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	search_mode = {
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "Enter", mods = "NONE", action = act.CopyMode("NextMatch") },
		{ key = "Enter", mods = "SHIFT", action = act.CopyMode("PriorMatch") },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
		{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
		{ key = "l", mods = "CTRL", action = act.CopyMode("ClearPattern") },
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

-- Tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = true
wezterm.on("update-status", function(window)
	-- Workspace name
	local stat = window:active_workspace()
	local stat_color = "#89b4fa"
	if window:active_key_table() then
		stat = window:active_key_table()
		stat_color = "#f38ba8"
	end
	if window:leader_is_active() then
		stat = "leader"
		stat_color = "#cba6f7"
	end

	-- Current command
	-- local cmd = pane:get_foreground_process_name()
	-- -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
	-- cmd = cmd and basename(cmd) or ""

	-- Left status (left of the tab line)
	window:set_left_status(wezterm.format({
		{ Foreground = { Color = stat_color } },
		{ Text = "  " },
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Text = " |" },
	}))
end)

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
