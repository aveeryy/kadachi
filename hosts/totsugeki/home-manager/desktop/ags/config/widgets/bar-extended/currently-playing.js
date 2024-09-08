const mpris = await Service.import("mpris");
const players = mpris.bind("players");

// TODO: rework
export const currently_playing_controller = Widget.Box({
  vertical: true,
  visible: players.as((p) => p.length > 0),
  children: players.as((p) => p.map(CurrentlyPlaying)),
});

function CurrentlyPlaying(player) {
  return Widget.Box({
    class_name: "currently-playing-big",
    css: player.bind("cover_path").as((url) => {
      if (url == undefined) {
        return "";
      }
      console.log(url);
      return `
            background-image: url('${url}');
            background-blend-mode: darken;
            background-position: center;
            background-size: cover;
        `;
    }),
    spacing: 4,
    children: [
      Widget.Box({
        class_name: "album-art-big",
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
      Widget.Box({
        children: [
          Widget.Label({
            class_name: "currently-playing-title",
            label: player.bind("track-title"),
            xalign: 0.5,
            hexpand: true,
            truncate: "end",
          }),
          Widget.Label({
            class_name: "currently-playing-artists",
            label: player.bind("track-artists").as((artists) => {
              return artists.join(", ");
            }),
            xalign: 0.5,
            hexpand: true,
            truncate: "end",
          }),
        ],
        vpack: "center",
        vertical: true,
      }),
      // Widget.Icon({
      //   class_name: "playback-status",
      //   icon: player.bind("play-back-status").as((status) => {
      //     if (status == "Playing") {
      //       return "media-playback-start";
      //     } else if (status == "Paused") {
      //       return "media-playback-pause";
      //     }
      //     return "";
      //   }),
      // }),
    ],
  });
}
