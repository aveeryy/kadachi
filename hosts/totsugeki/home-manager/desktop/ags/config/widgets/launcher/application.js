export const Application = (application) =>
  Widget.Button({
    class_name: "application",
    on_clicked: () => {
      App.closeWindow("launcher");
      application.launch();
    },
    attribute: { application },
    child: Widget.Box({
      children: [
        Widget.Icon({
          icon: application.icon_name || "",
          size: 24,
        }),
        Widget.Label({
          class_name: "application_name",
          label: application.name,
          xalign: 0,
          vpack: "center",
          truncate: "end",
        }),
      ],
      spacing: 4,
    }),
  });
