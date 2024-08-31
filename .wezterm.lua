local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.animation_fps = 60
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.ssh_domains = {
  {
    name = 'tomnuc',
    remote_address = 'home.andybarron.net',
    username = 'andy',
  },
}

return config
