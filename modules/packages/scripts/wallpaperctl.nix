{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.wallpaperctl = pkgs.writeShellApplication {
        name = "wallpaperctl";
        runtimeInputs = with pkgs; [
          imagemagick
          swww
          xdg-user-dirs
        ];
        bashOptions = [
          "errexit"
          "pipefail"
        ];
        meta.platforms = pkgs.lib.platforms.linux;
        text = ''
          shopt -s nullglob

          WALLPAPER_PATH="$(xdg-user-dir PICTURES)/Fondos"
          WALLPAPERS=("$WALLPAPER_PATH"/*)

          if [ ! -f "$WALLPAPER_PATH/.current_path" ]; then
              # Current wallpaper file does not exist, create it
              echo "''${WALLPAPERS[0]}" > "$WALLPAPER_PATH/.current_path"
          fi

          CURRENT_WALLPAPER=$(cat "$WALLPAPER_PATH/.current_path")
          current_index=-1
          # Get the current wallpaper's index
          for index in "''${!WALLPAPERS[@]}"; do
              if [ "''${WALLPAPERS[$index]}" = "$CURRENT_WALLPAPER" ]; then
                  current_index=$index
              fi
          done

          if [ "$current_index" -eq -1 ]; then
              current_index=0
          fi

          if [ "$1" = "previous" ]; then
              WALLPAPER="''${WALLPAPERS[$current_index - 1]}"
              TRANSITION_ANGLE=300
          elif [ "$1" = "next" ]; then
              next_index=$((current_index + 1))
              if [ "$next_index" = "''${#WALLPAPERS[@]}" ]; then
                  next_index=0
              fi
              WALLPAPER=''${WALLPAPERS[$next_index]}
              TRANSITION_ANGLE=120
          else
              echo "Unknown first argument: $1"
              exit 1
          fi

          if [ -z "$WALLPAPER" ]; then
              exit 1
          fi

          echo "Setting wallpaper to $WALLPAPER"
          echo "$WALLPAPER" > "$WALLPAPER_PATH/.current_path"
          ln -sf "$WALLPAPER" "$WALLPAPER_PATH/.current_image"

          swww img\
              --transition-type wipe\
              --transition-angle $TRANSITION_ANGLE\
              --transition-step 90\
              --transition-duration 1\
              --transition-fps 165\
              "$WALLPAPER" &

          # Extract the first frame of animated wallpapers for programs that do
          # not support them
          if [ -f "$WALLPAPER_PATH/.current_image_non_animated" ]; then
              rm -f "$WALLPAPER_PATH/.current_image_non_animated"
          fi
          if [ "$(magick identify "$WALLPAPER" | wc -l)" -gt 1 ]; then
              magick "''${WALLPAPER}[0]" "png:$WALLPAPER_PATH/.current_image_non_animated"
          else
             ln -sf "$WALLPAPER" "$WALLPAPER_PATH/.current_image_non_animated"
          fi
        '';
      };
    };
}
