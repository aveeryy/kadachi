import cpu from "./services/cpu.js";
import ram from "./services/ram.js";
import { launcher } from "./widgets/launcher/launcher.js";
const { speaker } = await Service.import("audio");
const mpris = await Service.import("mpris");
const sway = await Service.import("sway");
const players = mpris.bind("players");
const date = Variable("", {
  poll: [1000, 'date "+%H %M %S %b %e"'],
});

App.addIcons(`${App.configDir}/assets`);

function Workspaces() {
  return Widget.Box({
    children: Array.from({ length: 10 }, (_, i) => {
      i += 1;
      return Widget.Box({
        class_name: "workspace-button",
        children: [Widget.Label({ hexpand: true, label: i.toString() })],
        hpack: "center",
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
}

function ProcessorUsage() {
  return Widget.Box({
    class_name: "system-stats",
    css: cpu.bind("current-usage").as((usage) => {
      let level = (usage * 100).toFixed(0);
      return `
        background: linear-gradient(
            90deg, rgba(26, 27, 38, 0.6) ${level}%, rgba(26, 27, 38, 0.4) ${level}%
        )`;
    }),
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

function MemoryUsage() {
  return Widget.Box({
    class_name: "system-stats",
    css: ram.bind("current-usage-percentage").as((usage) => {
      let level = (usage * 100).toFixed(0);
      return `
        background: linear-gradient(
            90deg, rgba(26, 27, 38, 0.6) ${level}%, rgba(26, 27, 38, 0.4) ${level}%
        )`;
    }),
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
      return `${usageGb}/${totalGb}GB (${(ram.current_usage_percentage * 100).toFixed(2)}%)`;
    }),
    vertical: true,
  });
}

function CurrentSong(player) {
  return Widget.Box({
    class_name: "music-indicator",
    children: [
      Widget.Box({
        class_name: "album-art",
        css: player.bind("cover_path").as((url) => {
          if (url == undefined) {
            return `
                background-color: rgba(0, 0, 0, 0.2);
                background-image: url('${App.configDir}/assets/music-symbolic.svg');
                background-size: 50% 50%;
                background-repeat: no-repeat;
                background-position: center;
            `;
          }
          return `background-image: url('${url}'); background-size: cover;`;
        }),
      }),
      Widget.Icon({
        class_name: "playback-status",
        icon: player.bind("play-back-status").as((status) => {
          if (status == "Playing") {
            return "media-playback-start";
          } else if (status == "Paused") {
            return "media-playback-pause";
          }
          return "";
        }),
      }),
    ],
    // TODO: fill background based on track position
    css: player.bind("position").as((position) => {
      if (position == -1) {
        return "";
      }
      return "";
    }),
    vertical: true,
  });
}

function CTest() {
  // TODO: only show active player
  return Widget.Box({
    vertical: true,
    visible: players.as((p) => p.length > 0),
    children: players.as((p) => p.map(CurrentSong)),
  });
}

function ProfilePicture() {
  return Widget.Box({
    class_name: "profile-picture",
    css: "background-image: url('/home/avery/.face.icon'); background-size: cover",
  });
}

function VolumeWidget() {
  return Widget.Box({
    class_name: "volume-widget",
    children: [
      Widget.Icon({
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
        size: 10,
      }),
      Widget.Box({
        class_name: "volume-box",
        css: speaker.bind("volume").as((l) => {
          let level = l.toFixed(2) * 100;
          if (level >= 0 && level <= 100) {
            return `
            background: linear-gradient(
                90deg, #7aa2f7 ${level}%, #24283b ${level}%
            );
        `;
          } else if (level > 100 && level <= 200) {
            return `
            background: linear-gradient(
                90deg, #f7768e ${level - 100}%, #7aa2f7 ${level - 100}%
            );
        `;
          } else {
            return "background: #f7768e";
          }
        }),
        hpack: "fill",
      }),
    ],
  });
}
function ClockWidget() {
  return Widget.Box({
    children: [
      Widget.Label({
        class_name: "clock-hours",
        label: date.bind().as((d) => {
          return d.split(" ")[0];
        }),
      }),
      Widget.Label({
        class_name: "clock-minutes",
        label: date.bind().as((d) => {
          return d.split(" ")[1];
        }),
      }),
      Widget.Label({
        class_name: "clock-seconds",
        label: date.bind().as((d) => {
          return d.split(" ")[2];
        }),
      }),
    ],
    class_name: "clock",
    vertical: true,
  });
}

const barContainer = Widget.Box({
  class_name: "bar",
  vpack: "fill",
  spacing: 6,
  vertical: true,
  children: [
    Workspaces(),
    Widget.Box({ expand: true, vpack: "fill" }), // Separator
    CTest(),
    ProcessorUsage(),
    MemoryUsage(),
    ClockWidget(),
  ],
});

const bar = Widget.Window({
  name: "bar",
  anchor: ["left", "top", "bottom"],
  exclusivity: "exclusive",
  child: barContainer,
});

Utils.monitorFile(
  `${App.configDir}/style.css`,

  function () {
    App.resetCss;
    App.applyCss(`${App.configDir}/style.css`);
  },
);

App.config({
  style: "./style.css",
  windows: [bar, launcher],
});
