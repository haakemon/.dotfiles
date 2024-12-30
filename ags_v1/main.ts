import { Bar } from './modules/bar/main.js';
import { applauncher } from './modules/applauncher/main.js';
import { NotificationPopups } from './modules/notification-popups/notificationPopups.js';

Utils.timeout(100, () =>
  Utils.notify({
    summary: 'Notification Popup',
    iconName: undefined,
    body: 'Notifications active',
    actions: {
      Cool: () => print('OK'),
    },
  }),
);

Utils.monitorFile(`${App.configDir}/styles`, () => {
  const css = `${App.configDir}/styles/main.css`;

  App.resetCss();
  App.applyCss(css);
});

App.config({
  style: `${App.configDir}/styles/main.css`,
  closeWindowDelay: {
    'window-name': 500, // milliseconds
  },
  windows: [Bar(0), Bar(1), applauncher, NotificationPopups({ monitor: 0 }), NotificationPopups({ monitor: 1 })],
});
