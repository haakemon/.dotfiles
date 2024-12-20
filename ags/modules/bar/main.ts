const { query } = await Service.import('applications');

const mpris = await Service.import('mpris');
const audio = await Service.import('audio');
const battery = await Service.import('battery');
const systemtray = await Service.import('systemtray');

const date = Variable('', {
  poll: [1000, 'date "+%H:%M:%S %b %e."'],
});

function Clock() {
  return Widget.Label({
    class_name: 'clock',
    label: date.bind(),
  });
}

function Media() {
  const label = Utils.watch('', mpris, 'player-changed', () => {
    if (mpris.players[0]) {
      const { track_artists, track_title } = mpris.players[0];
      return `${track_artists.join(', ')} - ${track_title}`;
    } else {
      return 'Nothing is playing';
    }
  });

  return Widget.Button({
    class_name: 'media',
    on_primary_click: () => mpris.getPlayer('')?.playPause(),
    on_scroll_up: () => mpris.getPlayer('')?.next(),
    on_scroll_down: () => mpris.getPlayer('')?.previous(),
    child: Widget.Label({ label }),
  });
}

function Volume() {
  const icons = {
    101: 'overamplified',
    67: 'high',
    34: 'medium',
    1: 'low',
    0: 'muted',
  };

  function getIcon() {
    const icon = audio.speaker.is_muted
      ? 0
      : [101, 67, 34, 1, 0].find((threshold) => threshold <= audio.speaker.volume * 100);

    return `audio-volume-${icons[icon]}-symbolic`;
  }

  const icon = Widget.Icon({
    icon: Utils.watch(getIcon(), audio.speaker, getIcon),
  });

  const slider = Widget.Slider({
    hexpand: true,
    draw_value: false,
    on_change: ({ value }) => (audio.speaker.volume = value),
    setup: (self) =>
      self.hook(audio.speaker, () => {
        self.value = audio.speaker.volume || 0;
      }),
  });

  return Widget.Box({
    class_name: 'volume',
    css: 'min-width: 180px',
    children: [icon, slider],
  });
}

function BatteryLabel() {
  const value = battery.bind('percent').as((p) => (p > 0 ? p / 100 : 0));
  const icon = battery.bind('percent').as((p) => `battery-level-${Math.floor(p / 10) * 10}-symbolic`);
  // const icon = battery.bind('percent').as((p) => `battery-level${Math.floor(p / 10) * 10}-symbolic`);

  return Widget.Box({
    class_name: 'battery',
    visible: battery.bind('available'),
    children: [
      Widget.Icon({ icon }),
      Widget.LevelBar({
        widthRequest: 140,
        vpack: 'center',
        value,
      }),
    ],
  });
}

function SysTray() {
  const items = systemtray.bind('items').as((items) => {
    return items.map((item) =>
      Widget.Button({
        child: Widget.Icon({ icon: item.bind('icon') }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind('tooltip_markup'),
      }),
    );
  });

  return Widget.Box({
    children: items,
  });
}

// layout of the bar
function Left() {
  return Widget.Box({
    spacing: 8,
    children: [
      Widget.Button({
        class_name: 'bar-app',
        on_primary_click: () => query('wezterm')[0].launch(),
        child: Widget.Icon({ icon: 'utilities-terminal-symbolic' }),
        tooltip_text: 'WezTerm',
      }),
    ],
  });
}

function Center() {
  return Widget.Box({
    spacing: 8,
    children: [Media()],
  });
}

function Right() {
  return Widget.Box({
    hpack: 'end',
    spacing: 8,
    children: [
      Volume(),
      BatteryLabel(),
      SysTray(),
      Clock(),
      Widget.Button({
        class_name: 'bar-app',
        on_primary_click: () => Utils.exec('wlogout'),
        child: Widget.Icon({ icon: 'gnome-power-manager-symbolic' }),
        tooltip_text: 'Power',
      }),
    ],
  });
}

export function Bar(monitor = 0) {
  return Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });
}
