import { Clock } from "./big-clock.js";
import { currently_playing_controller } from "./currently-playing.js";
import { ProfileBlock } from "./profile-block.js";
import {
  graphics_card_usage,
  memory_usage,
  processor_usage,
  volume_widget,
} from "./system-stats-big.js";
import { workspaces } from "./workspaces.js";
import { on_window_event } from "../../state.js";

export const extended_bar = Widget.Window({
  name: "bar_extended",
  anchor: ["left", "top", "bottom"],
  margins: [4, 0, 4, 4],
  child: Widget.Box({
    class_names: ["bar", "extended_bar"],
    vpack: "fill",
    spacing: 6,
    vertical: true,
    children: [
      ProfileBlock(),
      workspaces,
      Widget.Box({ expand: true, vpack: "fill" }), // Separator
      // currently_playing_controller,
      processor_usage,
      memory_usage,
      graphics_card_usage,
      volume_widget,
      Widget.Calendar({}),
      Clock(),
    ],
  }),
  exclusivity: "ignore",
  visible: false,
  layer: "overlay",
  setup: (self) => {
    self.hook(App, (_, window_name, visible) => {
      if (window_name == self.name) {
        on_window_event(_, window_name, visible);
      }
    });
  },
});
