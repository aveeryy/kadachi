#!/bin/sh

missing_params() {
    echo "Missing parameters, usage: screenshot.sh <type>"
    exit 1
}

test -n 1 || missing_params

FILE_NAME=$(date +'Screenshot_%Y%m%d_%H%M%S')
TEMPORARY_PATH="/tmp/$FILE_NAME.png"
SCREENSHOT_PATH=$(xdg-user-dir PICTURES)/$FILE_NAME.jxl

if [ $1 == "full" ]; then
    grim $TEMPORARY_PATH
elif [ $1 == "section" ]; then
    grim -g "$(slurp -b '#000000aa' -w 0)" $TEMPORARY_PATH
fi
if [ $? == 0 ]; then
    wl-copy < $TEMPORARY_PATH
    cjxl $TEMPORARY_PATH $SCREENSHOT_PATH
    dunstify --raw_icon=$TEMPORARY_PATH "Captura de pantalla realizada" "Guardada como $FILE_NAME.jxl"
    rm $TEMPORARY_PATH
fi
