import { date } from "../../state.js";

function BlinkingDots() {
  return Widget.Label({
    class_name: "blinking-dots",
    label: ":",
  });
}

export function Clock() {
  return Widget.Box({
    children: [
      Widget.Box({ hexpand: true, hpack: "fill" }), // Separator
      Widget.Box({
        children: [
          Widget.Label({
            label: date.bind().as((d) => {
              return d.split(" ")[0];
            }),
          }),
          BlinkingDots(),
          Widget.Label({
            label: date.bind().as((d) => {
              return d.split(" ")[1];
            }),
          }),
          BlinkingDots(),
          Widget.Label({
            label: date.bind().as((d) => {
              return d.split(" ")[2];
            }),
          }),
        ],
      }),
      Widget.Box({ hexpand: true, hpack: "fill" }), // Separator
    ],
    class_names: ["clock", "clock-big"],
    hpack: "fill",
    spacing: 8,
  });
}
