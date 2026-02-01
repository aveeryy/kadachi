{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.screenshot = pkgs.writeShellApplication {
        name = "screenshot";
        bashOptions = [
          "errexit"
          "pipefail"
        ];
        meta.platforms = pkgs.lib.platforms.linux;
        runtimeInputs = with pkgs; [
          grim
          libjxl
          libnotify
          slurp
          wl-clipboard
          xdg-user-dirs
        ];
        text = ''
          usage() {
            echo "Usage: screenshot { full | section }"
            exit 1
          }

          test -n "$1" || usage

          FILE_NAME=$(date +'Captura_%Y%m%d_%H%M%S')
          TEMPORARY_PATH="/tmp/$FILE_NAME.png"
          SCREENSHOT_PATH="$(xdg-user-dir PICTURES)/Capturas/$FILE_NAME.jxl"
          if [ "$1" == "full" ]; then
            grim "$TEMPORARY_PATH"
          elif [ "$1" == "section" ]; then
            grim -g "$(slurp -b '#000000aa' -w 0)" "$TEMPORARY_PATH"
          else
            usage
          fi
          wl-copy < "$TEMPORARY_PATH"
          cjxl "$TEMPORARY_PATH" "$SCREENSHOT_PATH"
          rm "$TEMPORARY_PATH"
          notify-send\
            --icon="image-x-generic-symbolic"\
            --expire-time=2500\
            --app-name="Capturas de pantalla"\
            "Captura de pantalla realizada"\
            "Guardada como $FILE_NAME.jxl"
        '';
      };
    };
}
