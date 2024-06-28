{ pkgs }:

pkgs.writeShellApplication {
  name = "play-on-soundboard";
  runtimeInputs = with pkgs; [ mpv ];
  text = ''
    if [ ! -f "/run/user/$UID/soundboard.init" ]; then
      setup-soundboard
    fi
    mpv \
      --no-video\
      --audio-device=pipewire/Soundboard\
      --audio-client-name="Soundboard"\
      "$@"
  '';
}
