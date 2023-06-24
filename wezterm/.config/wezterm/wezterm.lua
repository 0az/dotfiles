local wezterm = require 'wezterm'
local config = {}


config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font 'DejaVu Sans Mono'
config.font_size = 20

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

return config
