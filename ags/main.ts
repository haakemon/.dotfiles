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

App.config({
  style: `${App.configDir}/style.css`,
  windows: [applauncher, NotificationPopups({ monitor: 0 }), NotificationPopups({ monitor: 1 })],
});
