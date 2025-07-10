import { For, createState } from 'ags';
import { Astal, Gtk, Gdk } from 'ags/gtk4';
import AstalApps from 'gi://AstalApps';
import Graphene from 'gi://Graphene';

const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

export default function Launcher() {
  let contentbox: Gtk.Box;
  let searchentry: Gtk.Entry;
  let win: Astal.Window;

  const apps = new AstalApps.Apps();
  const [list, setList] = createState(new Array<AstalApps.Application>());

  function search(text: string) {
    if (text === '') {
      setList([]);
    } else {
      setList(apps.fuzzy_query(text).slice(0, 8));
    }
  }

  function launch(app?: AstalApps.Application) {
    if (app) {
      win.hide();
      app.launch();
    }
  }

  // close on clickaway
  function handleClick(_e: Gtk.GestureClick, _: number, x: number, y: number) {
    const [, rect] = contentbox.compute_bounds(win);
    const position = new Graphene.Point({ x, y });

    if (!rect.contains_point(position)) {
      win.visible = false;
      return true;
    }
  }

  // close on ESC
  // start first fuzzy match on enter
  function handleKeyReleased(_e: Gtk.EventControllerKey, keyval: number, _: number, mod: number) {
    if (keyval === Gdk.KEY_Escape) {
      win.visible = false;
      return;
    }

    if (keyval === Gdk.KEY_Return) {
      launch(list.get()[0]);
      return;
    }
  }

  return (
    <window
      $={(ref) => (win = ref)}
      name="launcher"
      anchor={TOP | BOTTOM | LEFT | RIGHT}
      exclusivity={Astal.Exclusivity.IGNORE}
      keymode={Astal.Keymode.EXCLUSIVE}
      onNotifyVisible={({ visible }) => {
        if (visible) {
          searchentry.grab_focus();
        } else {
          searchentry.set_text('');
        }
      }}>
      <Gtk.EventControllerKey onKeyReleased={handleKeyReleased} />
      <Gtk.GestureClick onPressed={handleClick} />
      <box
        $={(ref) => (contentbox = ref)}
        name="launcher-content"
        valign={Gtk.Align.CENTER}
        halign={Gtk.Align.CENTER}
        orientation={Gtk.Orientation.VERTICAL}>
        <entry
          $={(ref) => (searchentry = ref)}
          onNotifyText={({ text }) => search(text)}
          placeholderText="Start typing to search"
        />
        <Gtk.Separator visible={list((l) => l.length > 0)} />
        <box orientation={Gtk.Orientation.VERTICAL}>
          <For each={list}>
            {(app) => {
              return (
                <button onClicked={() => launch(app)}>
                  <box>
                    <image iconName={app.iconName} />
                    <label label={app.name} maxWidthChars={40} wrap />
                  </box>
                </button>
              );
            }}
          </For>
        </box>
      </box>
    </window>
  );
}
