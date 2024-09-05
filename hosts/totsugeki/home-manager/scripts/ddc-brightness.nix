{ pkgs }:
pkgs.writeShellApplication {
  # Only for GIGABYTE G32QC monitor
  name = "ddc-brightness";
  runtimeInputs = with pkgs; [ ddcutil ];
  text = ''
    usage() {
        echo "Usage: ddc-brightness VALUE"
        echo "Possible values are +X, -X or X"
        exit 1
    }
    BRIGHTNESS_REGEX="^(-|\+)*[0-9]+$"
    test -n 1 || usage
    CACHE_FILE="/run/user/$UID/current-brightness"
    CURRENT_BRIGHTNESS=0
    if [ -f "$CACHE_FILE" ]; then
        CURRENT_BRIGHTNESS=$(cat "$CACHE_FILE")
    else
        CURRENT_BRIGHTNESS=$(ddcutil getvcp 10 | tr -s " " | cut -d " " -f 9 | tr -d ",")
        echo "$CURRENT_BRIGHTNESS" > "$CACHE_FILE"
    fi
    echo "Current brightness level is $CURRENT_BRIGHTNESS"
    if [[ ! "$1" =~ $BRIGHTNESS_REGEX ]]; then
      echo "Invalid value: '$1'"
      exit 1
    fi
    NEW_BRIGHTNESS_VALUE=0
    if [ "''${1:0:1}" == "+" ]; then
        NEW_BRIGHTNESS_VALUE=$(("$CURRENT_BRIGHTNESS" + "''${1:1}"))
    elif [ "''${1:0:1}" == "-" ]; then
        NEW_BRIGHTNESS_VALUE=$(("$CURRENT_BRIGHTNESS" - "''${1:1}"))
    else
        NEW_BRIGHTNESS_VALUE="$1"
    fi
    if [ "$NEW_BRIGHTNESS_VALUE" -lt 0 ]; then
        NEW_BRIGHTNESS_VALUE=0
    elif [ "$NEW_BRIGHTNESS_VALUE" -gt 100 ]; then
        NEW_BRIGHTNESS_VALUE=100
    fi
    echo "$NEW_BRIGHTNESS_VALUE" > "$CACHE_FILE"
    echo "Setting brightness level to $NEW_BRIGHTNESS_VALUE"
    ddcutil setvcp 10 "$NEW_BRIGHTNESS_VALUE"
    dunstify \
        --appname "volumectl"\
        --replace 9002\
        --urgency low\
        --timeout 1250\
        --hints "int:value:$NEW_BRIGHTNESS_VALUE"\
        "  $NEW_BRIGHTNESS_VALUE%"
  '';
}
