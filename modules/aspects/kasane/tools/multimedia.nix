{

  __findFile,
  lib,
  ...
}:
{
  kasane.tools._.multimedia = {
    includes = [
      (<adachi/desktop/default-applications/audio> [
        "mpv.desktop"
        "mediainfo-gui.desktop"
      ])
      (<adachi/desktop/default-applications/image> [
        "nsxiv.desktop"
        "gimp.desktop"
      ])
      (<adachi/desktop/default-applications/video> [
        "mpv.desktop"
        "mediainfo-gui.desktop"
      ])
    ];
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          # All formats
          ffmpeg-full
          mediainfo-gui
          # Media player and controls
          feishin
          playerctl
          # Audio tools
          sound-juicer
          picard
          # Audio and video tools
          handbrake
          mkvtoolnix
          # Image tools
          nsxiv
          gimp
          inkscape
        ];
        xdg.mimeApps.defaultApplications."image/svg" = lib.mkBefore [ "inkscape.desktop" ];
        dconf.settings."org/gnome/sound-juicer" = {
          # TODO: set output path
          audio-profile = "audio/x-flac";
          file-pattern = "%dn - %tt";
          path-pattern = "%aa/%at";
          strip-special = false;
        };
        programs.mpv = {
          enable = true;
          config = {
            screenshot-format = "png";
            # Disable HDR by default
            target-colorspace-hint = "no";
          };
          scripts = with pkgs.mpvScripts; [ mpris ];
        };
        wayland.windowManager.hyprland = {
          settings.bindl = [ "MOD3, m, submap, Música" ];

          extraConfig = ''
            submap = Música

            bindl = , p, exec, playerctl play-pause
            bindl = , h, exec, playerctl previous
            bindl = , l, exec, playerctl next
            bindl = , escape, submap, reset
            bindl = MOD3, m, submap, reset

            submap = reset
          '';
        };
      };
  };
}
