import { ProfilePicture } from "../bar/profile-picture.js";
import { CURRENT_USER, HOSTNAME } from "../../state.js";

const CURRENT_WALLPAPER_PATH =
  "/home/avery/.local/share/wallpapers/.current_path";

const wallpaperPath = Variable(Utils.readFile(CURRENT_WALLPAPER_PATH));

const wallpaperMonitor = Utils.monitorFile(
  CURRENT_WALLPAPER_PATH,
  (file, event) => {
    if (event === 1) {
      wallpaperPath.value = Utils.readFile(file);
    }
  },
);

export function ProfileBlock() {
  return Widget.Box({
    class_name: "profile_block",
    css: wallpaperPath.bind().as((path) => {
      path =
        path
          .replace("\n", "")
          .replace("/", "\\/")
          .replace("wallpapers", "wallpaper_thumbnails") + ".jpg";
      return `
        background-image: url('${path}');
        background-size: cover;
        background-position: center;
    `;
    }),
    spacing: 8,
    children: [
      ProfilePicture(40),
      Widget.Box({
        vertical: true,
        vpack: "center",
        children: [
          Widget.Label({
            class_name: "username",
            label: CURRENT_USER.real_name,
            xalign: 0,
          }),
          Widget.Label({
            class_name: "hostname",
            label: HOSTNAME,
            xalign: 0,
          }),
        ],
      }),
    ],
  });
}
