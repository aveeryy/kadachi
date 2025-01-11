import { ProfilePicture } from "./widgets/bar/profile-picture.js";
import {
  ProcessorUsage,
  MemoryUsage,
  graphics_card_usage,
  volume_widget,
} from "./widgets/bar/system-stats.js";
// import { extended_bar } from "./widgets/bar-extended/extended-bar.js";
import { launcher } from "./widgets/launcher/launcher.js";
import { popup_clock } from "./widgets/popup-clock/popup-clock.js";
import { date } from "./state.js";
const mpris = await Service.import("mpris");
// const sway = await Service.import("sway");
const hyprland = await Service.import("hyprland");
const players = mpris.bind("players");

App.addIcons(`${App.configDir}/assets`);

function Workspaces() {
  return Widget.Box({
    children: Array.from({ length: 10 }, (_, i) => {
      i += 1;
      return Widget.Label({
        class_name: "workspace-button",
        label: i.toString(),
        setup: (btn) => {
          btn.bind("prop", hyprland.active.workspace, "id", (id) => {
            btn.toggleClassName("active", id == i);
          });
        },
      });
    }),
    spacing: 4,
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
    // ProfilePicture(),
    Workspaces(),
    Widget.Box({ expand: true, vpack: "fill" }), // Separator
    // CTest(),
    ProcessorUsage(),
    MemoryUsage(),
    graphics_card_usage,
    volume_widget,
    ClockWidget(),
  ],
});

const bar = Widget.Window({
  name: "bar",
  anchor: ["left", "top", "bottom"],
  exclusivity: "exclusive",
  margins: [4, 0, 4, 4],
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
  windows: [bar, launcher, popup_clock],
});
