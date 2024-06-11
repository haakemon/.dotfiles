local wezterm = require('wezterm')
local act = wezterm.action

-- This table will hold the configuration.
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

math.randomseed(os.time())
local hue = math.random(0, 360);

-- config.color_scheme = 'Darcula (base16)'
config.color_scheme = 'Dracula'
config.font = wezterm.font 'Victor Mono'
config.window_background_gradient = {
  colors = { string.format("hwb(%f,%f%%,0%%)", hue, math.random(25, 40)), string.format("hwb(%f,0%%,%f%%)", hue, math.random(70, 100)) },
  blend = "Oklab",
  orientation = {
    Radial = {
      cx = 0.8,
      cy = 0.8,
      radius = 1.2,
    }
  },
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.scrollback_lines = 5000
config.audible_bell = "Disabled"
config.enable_scroll_bar = true
config.inactive_pane_hsb = {
  brightness = 0.9,
}
config.hide_mouse_cursor_when_typing = false
config.window_background_opacity = 0.97

config.window_close_confirmation = "NeverPrompt"


config.initial_cols = 156
config.initial_rows = 36

-- https://github.com/wez/wezterm/issues/4483#issuecomment-1835619115
-- config.enable_wayland = false


wezterm.on('update-status', function(window, pane)
  window:set_right_status(wezterm.format({
    { Foreground = { Color = "green" } },
    { Text = window:active_workspace() .. "  " },
  }))
end)

config.keys = {
  {
    key = 'e',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      -- Here you can dynamically construct a longer list if needed

      local home = wezterm.home_dir
      local workspaces = {
        { id = home .. '/',   label = 'default' },
        { id = home .. '/code',      label = 'code' },
        { id = home .. '/.dotfiles', label = 'dotfiles' },
      }

      window:perform_action(
        act.InputSelector {
          action = wezterm.action_callback(
            function(inner_window, inner_pane, id, label)
              if not id and not label then
                wezterm.log_info 'cancelled'
              else
                wezterm.log_info('id = ' .. id)
                wezterm.log_info('label = ' .. label)


  -- local first_tab, first_pane, window = wezterm.mux.spawn_window {}
  -- local _, second_pane, _ = window:spawn_tab {}


  -- first_tab:activate()

  -- first_pane:send_text 'asdfffffffffffff'
                inner_window:perform_action(
                  act.SwitchToWorkspace {
                    name = label,
                    spawn = {
                      label = 'Workspace: ' .. label,
                      cwd = id,
                    },
                  },
                  inner_pane
                )
              end
            end
          ),
          title = 'Choose Workspace',
          choices = workspaces,
          fuzzy = true,
          fuzzy_description = 'Fuzzy find and/or make a workspace',
        },
        pane
      )
    end),
  },
}

wezterm.on('gui-startup', function()
  local first_tab, first_pane, window = wezterm.mux.spawn_window {}
  -- local _, second_pane, _ = window:spawn_tab {}
  -- local _, third_pane, _ = window:spawn_tab {}

  first_tab:activate()
  -- first_pane:send_text 'devenv dotnet7\nasdf\n'
end)

-- config.unix_domains = { {
--   name = 'unix'
-- } }

-- config.default_gui_startup_args = { 'connect', 'unix' }

return config
