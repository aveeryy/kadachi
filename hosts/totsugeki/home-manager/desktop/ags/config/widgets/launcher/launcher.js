import { Application } from "./application.js";
import { on_window_event } from "../../state.js";
const { query, reload } = await Service.import("applications");

const Launcher = () => {
  let applications = query("").map(Application);

  const list = Widget.Box({
    css: "background-color: transparent",
    vertical: true,
    spacing: 4,
    children: applications,
  });

  function repopulate() {
    reload();
    applications = query("").map(Application);
    list.children = applications;
  }

  const searchBox = Widget.Entry({
    class_name: "launcher-search",
    hexpand: true,
    placeholder_text: "Buscar",
    xalign: 0.5,
    on_accept: () => {
      const results = applications.filter((item) => item.visible);
      if (results[0]) {
        App.closeWindow("launcher");
        results[0].attribute.application.launch();
      }
    },
    on_change: ({ text }) => {
      text = text.toLowerCase();
      list.children = applications.sort((a, b) => {
        var firstMatches = a.attribute.application.name
          .toLowerCase()
          .match(text ?? "");
        var secondMatches = b.attribute.application.name
          .toLowerCase()
          .match(text ?? "");
        if (firstMatches && secondMatches) {
          return 0;
        } else if (firstMatches) {
          return -1;
        }
        return 1;
      });

      applications.forEach((item) => {
        item.visible = item.attribute.application.match(text ?? "");
      });
    },
  });

  return Widget.Box({
    class_name: "launcher",
    vertical: true,
    spacing: 4,
    children: [
      searchBox,
      Widget.Scrollable({
        hscroll: "never",
        child: list,
        vexpand: true,
      }),
    ],
    setup: (self) =>
      self.hook(App, (_, window_name, visible) => {
        if (window_name == "launcher" && visible) {
          repopulate();
          applications[0].grab_focus(); // Scrolls application list to top
          searchBox.text = "";
          searchBox.grab_focus();
        }
      }),
  });
};

export const launcher = Widget.Window({
  name: "launcher",
  anchor: ["left", "top", "bottom"],
  setup: (self) => {
    self.hook(App, (_, window_name, visible) => {
      if (window_name == self.name) {
        on_window_event(_, window_name, visible);
      }
    });
    self.keybind("Escape", () => {
      App.closeWindow("launcher");
    });
  },
  visible: false,
  margins: [4, 0, 4, 4],
  exclusivity: "ignore",
  keymode: "exclusive",
  child: Launcher({}),
});
