// TODO: user-agnostic, reload if changed
export function ProfilePicture(size = 32) {
  return Widget.Box({
    class_name: "profile-picture",
    css: `
        background-image: url('/home/avery/.face.icon');
        background-size: cover;
        min-width: ${size}px;
        min-height: ${size}px;
    `,
  });
}
