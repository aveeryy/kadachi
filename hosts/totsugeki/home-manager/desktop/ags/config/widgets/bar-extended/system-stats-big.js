import cpu from "../../services/cpu.js";
import ram from "../../services/ram.js";
import gpu from "../../services/gpu.js";
const { speaker } = await Service.import("audio");

const PROCESSOR_NAME = Utils.exec(
  'bash -c \'cat /proc/cpuinfo | grep "model name" | head -n 1 | cut -d ":" -f 2 | cut -d " " -f 3,4,5\'',
);
const GRAPHICS_CARD_NAME = "Radeon RX 6700 XT";

export const processor_usage = Widget.Box({
  class_names: ["system-stats", "system-stats-big"],
  css: cpu.bind("current-usage").as((usage) => {
    let level = (usage * 100).toFixed(0);
    return `
        background: linear-gradient(
            90deg, rgba(0, 0, 0, 0.4) ${level}%, rgba(0, 0, 0, 0) ${level}%
        )`;
  }),
  spacing: 6,
  children: [
    Widget.Icon({
      class_names: ["system-stats-icon"],
      icon: "microchip-symbolic",
      size: 16,
    }),
    Widget.Label({
      class_name: "system-stats-title",
      label: PROCESSOR_NAME,
    }),
    Widget.Label({
      class_name: "system-stats-text-big",
      hexpand: true,
      xalign: 1,
      label: cpu.bind("current-usage").as((usage) => {
        return `${(usage * 100).toFixed(0)}% (${cpu.temperature.toFixed(0)}ºC)`;
      }),
    }),
  ],
});

export const memory_usage = Widget.Box({
  class_names: ["system-stats", "system-stats-big"],
  css: ram.bind("current-usage-percentage").as((usage) => {
    let level = (usage * 100).toFixed(0);
    return `
        background: linear-gradient(
            90deg, rgba(0, 0, 0, 0.4) ${level}%, rgba(0, 0, 0, 0) ${level}%
        )`;
  }),
  spacing: 6,
  children: [
    Widget.Icon({
      class_names: ["system-stats-icon"],
      icon: "ram-custom-symbolic",
      size: 16,
    }),
    Widget.Label({
      class_name: "system-stats-title",
      label: "Memoria",
    }),
    Widget.Label({
      class_name: "system-stats-text-big",
      hexpand: true,
      xalign: 1,
      label: ram.bind("current-usage").as((usage) => {
        let usageGb = (usage / 1024 ** 2).toFixed(2);
        let totalGb = (ram.total_available / 1024 ** 2).toFixed(2);
        return `${usageGb}/${totalGb}GiB (${(ram.current_usage_percentage * 100).toFixed(2)}%)`;
      }),
    }),
  ],
});

export const graphics_card_usage = Widget.Box({
  class_names: ["system-stats", "system-stats-big"],
  css: gpu.bind("current-usage").as((usage) => {
    var level = Number(usage).toFixed(0);
    return `
        background: linear-gradient(
            90deg, rgba(0, 0, 0, 0.4) ${level}%, rgba(0, 0, 0, 0) ${level}%
        )`;
  }),
  spacing: 6,
  children: [
    Widget.Icon({
      class_names: ["system-stats-icon"],
      icon: "gpu-symbolic",
      size: 16,
    }),
    Widget.Label({
      class_name: "system-stats-title",
      label: GRAPHICS_CARD_NAME,
    }),
    Widget.Label({
      class_name: "system-stats-text-big",
      hexpand: true,
      xalign: 1,
      label: gpu.bind("current-usage").as((usage) => {
        return `${Number(usage).toFixed(0)}% (${gpu.temperature.toFixed(0)}ºC)`;
      }),
    }),
  ],
});

export const volume_widget = Widget.Box({
  class_names: ["system-stats", "system-stats-big"],
  css: speaker.bind("volume").as((l) => {
    let level = l.toFixed(2) * 100;
    if (level >= 0 && level <= 100) {
      return `
        background: linear-gradient(
            90deg, rgba(0, 0, 0, 0.4) ${level}%, rgba(0, 0, 0, 0) ${level}%
        );`;
    } else if (level > 100 && level <= 200) {
      return `
       background: linear-gradient(
           90deg, rgba(226, 27, 38, 0.4) ${level - 100}%, rgba(0, 0, 0, 0.4) ${level - 100}%
       );`;
    } else {
      return "background: rgba(226, 27, 38, 0.4)";
    }
  }),
  spacing: 6,
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
      class_name: "system-stats-title",
      label: "Volumen",
    }),
    Widget.Label({
      class_name: "system-stats-text-big",
      hexpand: true,
      xalign: 1,
      label: speaker.bind("volume").as((l) => {
        return `${(l * 100).toFixed(0)}%`;
      }),
    }),
  ],
});
