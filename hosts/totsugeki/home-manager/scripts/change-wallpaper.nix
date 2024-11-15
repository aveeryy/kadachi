{ pkgs }:

pkgs.writeShellApplication {
  name = "change-wallpaper";
  runtimeInputs = with pkgs; [ dunst rofi swww ];
  text = ''
    shopt -s nullglob

    WALLPAPER_PATH="$HOME/.local/share/wallpapers"
    WALLPAPERS=("$WALLPAPER_PATH"/*)

    if [ ! -f "$WALLPAPER_PATH/.current_path" ]; then
        # Current wallpaper file does not exist, create it
        echo "''${WALLPAPERS[0]}" > "$WALLPAPER_PATH/.current_path"
    fi

    CURRENT_WALLPAPER=$(cat "$WALLPAPER_PATH/.current_path")
    CURRENT_WP_INDEX=-1
    # Get the current wallpaper's index
    for index in "''${!WALLPAPERS[@]}"; do
        if [ "''${WALLPAPERS[$index]}" = "$CURRENT_WALLPAPER" ]; then
            CURRENT_WP_INDEX=$index
        fi
    done

    if [ "$CURRENT_WP_INDEX" -eq -1 ]; then
        CURRENT_WP_INDEX=0
    fi

    if [ "$1" = "previous" ]; then
        WALLPAPER="''${WALLPAPERS[$CURRENT_WP_INDEX - 1]}"
        TRANSITION_ANGLE=300
    elif [ "$1" = "next" ]; then
        NEXT_INDEX=$((CURRENT_WP_INDEX + 1))
        if [ "$NEXT_INDEX" = "''${#WALLPAPERS[@]}" ]; then
            NEXT_INDEX=0
        fi
        WALLPAPER=''${WALLPAPERS[$NEXT_INDEX]}
        TRANSITION_ANGLE=120
    elif [ "$1" = "open-menu" ]; then
        INPUT=""
        for index in "''${!WALLPAPERS[@]}"; do
            if [ "$index" = "$CURRENT_WP_INDEX" ]; then
                continue
            fi
            _WALLPAPER=''${WALLPAPERS[$index]}
            _WALLPAPER_NAME=$(basename "$_WALLPAPER")
            INPUT+="$_WALLPAPER_NAME\0icon\x1f$_WALLPAPER"
            if [ ! $((index + 1)) -eq ''${#WALLPAPERS[@]} ]; then
                INPUT+=$'\n'
            fi
        done
        if ! WALLPAPER=$(echo -en "$INPUT" | rofi -dmenu -mesg "Cambiar fondo de pantalla" -p "" -i -theme ~/.config/rofi/wallpaper_selector.rasi); then
            exit 1
        fi
        WALLPAPER="$WALLPAPER_PATH/$WALLPAPER"
        TRANSITION_ANGLE=270
    else
        echo "Unknown first argument: $1"
        exit 1
    fi

    if [ -z "$WALLPAPER" ]; then
        exit 1
    fi

    WALLPAPER_NAME=$(basename "$WALLPAPER")
    echo "Setting wallpaper to $WALLPAPER"
    echo "$WALLPAPER" > "$WALLPAPER_PATH/.current_path"
    ln -sf "$WALLPAPER" "$WALLPAPER_PATH/.current_image"
    swww img\
        --transition-type wipe\
        --transition-angle $TRANSITION_ANGLE\
        --transition-step 90\
        --transition-duration 1\
        --transition-fps 165\
        "$WALLPAPER"
    dunstify -i "$WALLPAPER" -t 2800 "Cambiando fondo de pantalla" "Cambiando a $WALLPAPER_NAME"
  '';
}
