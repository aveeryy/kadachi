{ pkgs }:

pkgs.writeShellApplication {
  name = "get_fancy_currently_playing";
  runtimeInputs = [ pkgs.playerctl ];
  text = ''
    STRING=""
    case $(playerctl status 2> /dev/stdout) in
        "Playing")
            STRING+="⏵ "
            ;;
        "Paused")
            STRING+="⏸ "
            ;;
        "No players found")
            exit 1
            ;;
    esac
    ARTIST=$(playerctl metadata xesam:artist)
    if [[ -n $ARTIST ]]; then
      STRING+="$ARTIST // "
    fi
    TITLE=$(playerctl metadata xesam:title)
    if [[ -n $TITLE ]]; then
      STRING+="$TITLE"
    fi
    echo -e "$STRING"
  '';
}
