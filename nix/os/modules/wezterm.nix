{ config }:

{

  home-manager.users.${config.configOptions.username} = { config, pkgs, ... }: {
    programs = {
      wezterm = {
        enable = true;
        extraConfig = ''
          local wezterm = require('wezterm')
          local act = wezterm.action

          local wezterm = require('wezterm')
          local act = wezterm.action

          local config = {}
          if wezterm.config_builder then
            config = wezterm.config_builder()
          end

          math.randomseed(os.time())
          local hue = math.random(0, 360);

          -- config.color_scheme = 'Darcula (base16)'
          config.color_scheme = 'Dracula'
          config.font = wezterm.font 'Victor Mono'

          config.scrollback_lines = 5000
          config.audible_bell = "Disabled"
          config.enable_scroll_bar = true
          config.hide_mouse_cursor_when_typing = false
          config.window_background_opacity = 0.8
          config.window_close_confirmation = "NeverPrompt"

          config.initial_cols = 156
          config.initial_rows = 36

          config.keys = {
            { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
            { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'Clipboard' },
          }

          return config
        '';
      };
    };
  };
}
