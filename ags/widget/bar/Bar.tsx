import app from 'ags/gtk4/app';
import GLib from 'gi://GLib';
import Astal from 'gi://Astal?version=4.0';
import Gtk from 'gi://Gtk?version=4.0';
import Gdk from 'gi://Gdk?version=4.0';
import AstalBattery from 'gi://AstalBattery';
import AstalPowerProfiles from 'gi://AstalPowerProfiles';
import AstalWp from 'gi://AstalWp';
import AstalNetwork from 'gi://AstalNetwork';
import AstalTray from 'gi://AstalTray';
import AstalMpris from 'gi://AstalMpris';
import AstalApps from 'gi://AstalApps';
import { For, With, createBinding } from 'ags';
import { createPoll } from 'ags/time';
import { exec, execAsync } from 'ags/process';

function Tray() {
  const tray = AstalTray.get_default();
  const items = createBinding(tray, 'items');

  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel;
    btn.insert_action_group('dbusmenu', item.actionGroup);
    item.connect('notify::action-group', () => {
      btn.insert_action_group('dbusmenu', item.actionGroup);
    });
  };

  return (
    <box>
      <For each={items}>
        {(item) => (
          <menubutton $={(self) => init(self, item)}>
            <image gicon={createBinding(item, 'gicon')} />
          </menubutton>
        )}
      </For>
    </box>
  );
}

function Wireless() {
  const network = AstalNetwork.get_default();
  const wifi = createBinding(network, 'wifi');

  const sorted = (arr: Array<AstalNetwork.AccessPoint>) => {
    return arr.filter((ap) => !!ap.ssid).sort((a, b) => b.strength - a.strength);
  };

  async function connect(ap: AstalNetwork.AccessPoint) {
    // connecting to ap is not yet supported
    // https://github.com/Aylur/astal/pull/13
    try {
      await execAsync(`nmcli d wifi connect ${ap.bssid}`);
    } catch (error) {
      // you can implement a popup asking for password here
      console.error(error);
    }
  }

  return (
    <box visible={wifi(Boolean)}>
      <With value={wifi}>
        {(wifi) =>
          wifi && (
            <menubutton>
              <image iconName={createBinding(wifi, 'iconName')} />
              <popover>
                <box orientation={Gtk.Orientation.VERTICAL}>
                  <For each={createBinding(wifi, 'accessPoints')(sorted)}>
                    {(ap: AstalNetwork.AccessPoint) => (
                      <button onClicked={() => connect(ap)}>
                        <box spacing={4}>
                          <image iconName={createBinding(ap, 'iconName')} />
                          <label label={createBinding(ap, 'ssid')} />
                          <image
                            iconName="object-select-symbolic"
                            visible={createBinding(wifi, 'activeAccessPoint')((active) => active === ap)}
                          />
                        </box>
                      </button>
                    )}
                  </For>
                </box>
              </popover>
            </menubutton>
          )
        }
      </With>
    </box>
  );
}

function AudioOutput() {
  const { defaultSpeaker: speaker } = AstalWp.get_default()!;

  return (
    <button
      onClicked={() => {
        exec(['bash', '-c', 'pavucontrol']);
      }}>
      <image iconName={createBinding(speaker, 'volumeIcon')} />
    </button>
  );
}

function PowerMenu() {
  const { defaultSpeaker: speaker } = AstalWp.get_default()!;

  return (
    <button
      onClicked={() => {
        exec(['bash', '-c', 'wlogout']);
      }}>
      <image iconName="dialog-password-symbolic" />
    </button>
  );
}

function AudioSlider() {
  const { defaultSpeaker: speaker } = AstalWp.get_default()!;

  return (
    <box class="slider-box">
      <slider
        widthRequest={200}
        min={0}
        max={1}
        onChangeValue={({ value }) => speaker.set_volume(value)}
        value={createBinding(speaker, 'volume')}
      />
    </box>
  );
}

function Battery() {
  const battery = AstalBattery.get_default();
  const powerprofiles = AstalPowerProfiles.get_default();

  const percent = createBinding(battery, 'percentage')((p) => `${Math.floor(p * 100)}%`);

  const setProfile = (profile: string) => {
    powerprofiles.set_active_profile(profile);
  };

  return (
    <menubutton visible={createBinding(battery, 'isPresent')}>
      <box>
        <image iconName={createBinding(battery, 'iconName')} />
        <label label={percent} />
      </box>
      <popover>
        <box orientation={Gtk.Orientation.VERTICAL}>
          {powerprofiles.get_profiles().map(({ profile }) => (
            <button onClicked={() => setProfile(profile)}>
              <label label={profile} xalign={0} />
            </button>
          ))}
        </box>
      </popover>
    </menubutton>
  );
}

function Clock({ format = '%H:%M:%S %e. %b' }) {
  const time = createPoll('', 1000, () => {
    return GLib.DateTime.new_now_local().format(format)!;
  });

  return (
    <menubutton>
      <label label={time} />
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  );
}

export default function Bar() {
  const monitors = createBinding(app, 'monitors');
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <For each={monitors} cleanup={(win) => (win as Gtk.Window).destroy()}>
      {(monitor) => (
        <window
          visible
          name="bar"
          gdkmonitor={monitor}
          exclusivity={Astal.Exclusivity.EXCLUSIVE}
          anchor={TOP | LEFT | RIGHT}
          application={app}>
          <centerbox>
            <box $type="start"></box>
            <box $type="end">
              <Tray />
              <Wireless />
              <box>
                <AudioOutput />
                <AudioSlider />
              </box>
              <Battery />
              <Clock />
              <PowerMenu />
            </box>
          </centerbox>
        </window>
      )}
    </For>
  );
}
