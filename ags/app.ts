import { App } from 'astal/gtk3';
import style from './style.scss';
import Bar from './widget/bar/Bar';
import NotificationPopups from './widget/notification/Popups';
import AppLauncher from './widget/applauncher/Launcher';

App.start({
  css: style,
  instanceName: 'astal',
  requestHandler(request, res) {
    print(request);
    res('ok');
  },
  main: () => {
    App.get_monitors().map(Bar);
    AppLauncher().hide();
    App.get_monitors().map(NotificationPopups);
  },
});
