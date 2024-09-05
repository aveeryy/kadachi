import { Application } from "./application.js";
const { query } = await Service.import("applications");

const Launcher = ({ width = 500, height = 600, spacing = 4 }) => {
  let applications = query("").map(Application);

  const list = Widget.Box({
    css: "background-color: transparent",
    vertical: true,
    spacing,
    children: applications,
  });

  function repopulate() {
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
    spacing,
    children: [
      searchBox,
      Widget.Scrollable({
        hscroll: "never",
        css: `min-width: ${width}px; min-height: ${height}px;`,
        child: list,
        vexpand: true,
      }),
    ],
    setup: (self) =>
      self.hook(App, (_, windowName, visible) => {
        if (windowName == "launcher" && visible) {
          repopulate();
          searchBox.text = "";
          searchBox.grab_focus();
        }
      }),
  });
};

export const launcher = Widget.Window({
  name: "launcher",
  setup: (self) =>
    self.keybind("Escape", () => {
      App.closeWindow("launcher");
    }),
  visible: false,
  keymode: "exclusive",
  child: Launcher({}),
});
