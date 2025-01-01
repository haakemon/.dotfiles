import { App, Gdk, Gtk } from 'astal/gtk3';
import style from './style.scss';
import Bar from './widget/bar/Bar';
import NotificationPopups from './widget/notification/Popups';
import AppLauncher from './widget/applauncher/Launcher';

function main() {
  AppLauncher().hide();

  const bars = new Map<Gdk.Monitor, Gtk.Widget>();
  const popups = new Map<Gdk.Monitor, Gtk.Widget>();

  // initialize
  for (const gdkmonitor of App.get_monitors()) {
    print('initialize', JSON.stringify(gdkmonitor.get_model()));
    bars.set(gdkmonitor, Bar(gdkmonitor));
    popups.set(gdkmonitor, NotificationPopups(gdkmonitor));
  }

  App.connect('monitor-added', (_, gdkmonitor) => {
    print('monitor-added', JSON.stringify(gdkmonitor.get_model()));
    bars.set(gdkmonitor, Bar(gdkmonitor));
    popups.set(gdkmonitor, NotificationPopups(gdkmonitor));
  });

  App.connect('monitor-removed', (_, gdkmonitor) => {
    print('monitor-removed', JSON.stringify(gdkmonitor.get_model()));
    bars.get(gdkmonitor)?.destroy();
    bars.delete(gdkmonitor);

    popups.get(gdkmonitor)?.destroy();
    popups.delete(gdkmonitor);
  });
}

App.start({
  css: style,
  instanceName: 'astal',
  requestHandler(request, res) {
    print(request);
    res('ok');
  },
  main,
});
