import cpu from "../../services/cpu.js";
import gpu from "../../services/gpu.js";
import ram from "../../services/ram.js";
const { speaker } = await Service.import("audio");

export function ProcessorUsage() {
  return Widget.Box({
    class_name: "system-stats",
    css: cpu.bind("current-usage").as((usage) => {
      let level = (usage * 100).toFixed(0);
      return `
        background: linear-gradient(
            90deg, rgba(0, 0, 0, 0.2) ${level}%, rgba(0, 0, 0, 0) ${level}%
        )`;
    }),
    spacing: 2,
    children: [
      Widget.Icon({
        class_names: ["system-stats-icon"],
        icon: "microchip-symbolic",
        size: 16,
      }),
      Widget.Label({
        class_names: ["system-stats-text"],
        hexpand: true,
        label: cpu.bind("current-usage").as((usage) => {
          return `${(usage * 100).toFixed(0)}%`;
        }),
      }),
    ],
    vertical: true,
  });
}

export function MemoryUsage() {
  return Widget.Box({
    class_name: "system-stats",
    css: ram.bind("current-usage-percentage").as((usage) => {
      let level = (usage * 100).toFixed(0);
      return `
        background: linear-gradient(
            90deg, rgba(0, 0, 0, 0.2) ${level}%, rgba(0, 0, 0, 0) ${level}%
        )`;
    }),
    spacing: 2,
    children: [
      Widget.Icon({
        class_names: ["system-stats-icon"],
        icon: "ram-custom-symbolic",
        size: 16,
      }),
      Widget.Label({
        class_names: ["system-stats-text"],
        hexpand: true,
        label: ram.bind("current-usage-percentage").as((usage) => {
          return `${(usage * 100).toFixed(0)}%`;
        }),
      }),
    ],
    tooltip_text: ram.bind("current-usage").as((usage) => {
      let usageGb = (usage / 1024 ** 2).toFixed(2);
      let totalGb = (ram.total_available / 1024 ** 2).toFixed(2);
      return `${usageGb}/${totalGb}GiB (${(ram.current_usage_percentage * 100).toFixed(2)}%)`;
    }),
    vertical: true,
  });
}

export const graphics_card_usage = Widget.Box({
  class_name: "system-stats",
  css: gpu.bind("current-usage").as((usage) => {
    var level = Number(usage).toFixed(0);
    return `
        background: linear-gradient(
            90deg, rgba(0, 0, 0, 0.2) ${level}%, rgba(0, 0, 0, 0) ${level}%
        )`;
  }),
  spacing: 2,
  children: [
    Widget.Icon({
      class_names: ["system-stats-icon"],
      icon: "gpu-symbolic",
      size: 16,
    }),
    Widget.Label({
      class_names: ["system-stats-text"],
      hexpand: true,
      label: gpu.bind("current-usage").as((usage) => {
        return `${Number(usage).toFixed(0)}%`;
      }),
    }),
  ],
  vertical: true,
});

export const volume_widget = Widget.Box({
  class_name: "system-stats",
  css: speaker.bind("volume").as((l) => {
    let level = l.toFixed(2) * 100;
    if (level >= 0 && level <= 100) {
      return `
        background: linear-gradient(
            90deg, rgba(0, 0, 0, 0.2) ${level}%, rgba(0, 0, 0, 0) ${level}%
        );`;
    } else if (level > 100 && level <= 200) {
      return `
       background: linear-gradient(
           90deg, rgba(226, 27, 38, 0.4) ${level - 100}%, rgba(0, 0, 0, 0.2) ${level - 100}%
       );`;
    } else {
      return "background: rgba(226, 27, 38, 0.4)";
    }
  }),
  spacing: 2,
  vertical: true,
  children: [
    Widget.Icon({
      class_names: ["system-stats-icon"],
      icon: speaker.bind("volume").as((l) => {
        let level = l.toFixed(2) * 100;
        if (level == 0) {
          return "audio-volume-muted";
        } else if (level > 0 && level <= 30) {
          return "audio-volume-low";
        } else if (level > 30 && level <= 70) {
          return "audio-volume-medium";
        } else {
          return "audio-volume-high";
        }
      }),
      size: 16,
    }),
    Widget.Label({
      class_name: "system-stats-text",
      hexpand: true,
      label: speaker.bind("volume").as((l) => {
        return `${(l * 100).toFixed(0)}%`;
      }),
    }),
  ],
});
