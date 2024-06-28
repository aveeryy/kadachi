{ pkgs }:

pkgs.writeShellApplication {
  name = "setup-soundboard";
  text = ''
    touch "/run/user/$UID/soundboard.init"
    pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="Soundboard" node.description="Soundboard" media.class=Audio/Sink object.linger=true audio.position=[FL FR] }'
    pw-link Soundboard:monitor_FL easyeffects_source:input_FL
    pw-link Soundboard:monitor_FR easyeffects_source:input_FR
    pw-link Soundboard:monitor_FL easyeffects_sink:playback_FL
    pw-link Soundboard:monitor_FR easyeffects_sink:playback_FR
  '';
}
