const sway = await Service.import("sway");

function getWorkspaceWindows(node) {
  var nodes = [];
  node.nodes.concat(node.floating_nodes).forEach((child_node) => {
    if (
      child_node.app_id != undefined ||
      child_node.window_properties != undefined
    ) {
      nodes.push(child_node);
    } else {
      nodes = nodes.concat(getWorkspaceWindows(child_node));
    }
  });
  return nodes;
}

export const workspaces = Widget.Box({
  children: Array.from({ length: 10 }, (_, i) => {
    i += 1;
    return Widget.Box({
      class_names: ["workspace-button", "workspace-button-big"],
      spacing: 16,
      children: [
        Widget.Label({
          class_name: "workspace-name",
          label: `Escritorio ${i.toString()}`,
        }),
        Widget.Box({
          children: [
            Widget.Label({
              label: "dummy",
              hexpand: true,
              xalign: 1,
              truncate: "end",
              setup: (label) => {
                label.hook(sway, (label) => {
                  const ws = sway.getWorkspace(`${i}`);
                  if (ws === undefined) {
                    label.visible = false;
                    return;
                  }
                  var nodes = getWorkspaceWindows(ws);
                  if (nodes.length == 1) {
                    label.label = nodes[0].name;
                    label.visible = true;
                  } else if (nodes.length > 0) {
                    label.label = `${nodes.length} ventanas abiertas`;
                    label.visible = true;
                  } else {
                    label.label = "No hay ventanas abiertas";
                    label.visible = false;
                  }
                });
              },
            }),
          ],
        }),
      ],
      setup: (btn) => {
        btn.hook(
          sway,
          (btn) => {
            const ws = sway.getWorkspace(`${i}`);
            btn.toggleClassName(
              "occupied",
              ws?.nodes.length + ws?.floating_nodes.length > 0,
            );
          },
          "notify::workspaces",
        );

        btn.hook(sway.active.workspace, (btn) => {
          btn.toggleClassName("active", sway.active.workspace.name == i);
        });
      },
    });
  }),
  spacing: 4,
  vertical: true,
});
