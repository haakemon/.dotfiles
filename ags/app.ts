import app from 'ags/gtk4/app';
import GLib from 'gi://GLib';
import Gtk from 'gi://Gtk?version=4.0';

import style from './style.scss';

import Applauncher from './widget/launcher/Launcher';
import NotificationPopups from './widget/notification/NotificationPopups';
import Bar from './widget/bar/Bar';

let applauncher: Gtk.Window;

function main() {
  applauncher = Applauncher() as Gtk.Window;
  app.add_window(applauncher);

  Bar();
  NotificationPopups();
}

app.start({
  css: style,
  gtkTheme: 'Adwaita',
  requestHandler(request, res) {
    const [, argv] = GLib.shell_parse_argv(request);
    if (!argv) return res('argv parse error');

    switch (argv[0]) {
      case 'toggle':
        applauncher.visible = !applauncher.visible;
        return res('ok');
      default:
        return res('unknown command');
    }
  },
  main,
});
