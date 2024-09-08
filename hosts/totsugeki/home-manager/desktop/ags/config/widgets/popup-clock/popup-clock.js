import { Clock } from "../bar-extended/big-clock.js";

export const popup_clock = Widget.Window({
  name: "popup_clock",
  visible: false,
  anchor: ["right", "top"],
  margins: [16, 16, 0, 0],
  layer: "overlay",
  child: Clock(),
});
