-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'
config.window_background_opacity = 0.8
config.window_decorations = "RESIZE"
config.enable_wayland = true
config.use_fancy_tab_bar = false
config.font = wezterm.font("CommitMono")
config.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 5000




-- wezterm.on('update-right-status', function(window, pane)
--   -- Get the formatted date string
--   local date = wezterm.strftime '%a | %b %-d'

--   -- Color palette for the background of the cell
--   local colors = { '#3c1361' }

--   -- Foreground color for the text
--   local text_fg = '#c0c0c0'

--   -- Elements to be formatted
--   local elements = {
--     { Foreground = { Color = text_fg } },
--     { Background = { Color = colors[1] } },
--     { Text = ' ' .. date .. ' ' },
--   }

--   -- Set the right status
--   window:set_right_status(wezterm.format(elements))
-- end)



-- and finally, return the configuration to wezterm
return config
