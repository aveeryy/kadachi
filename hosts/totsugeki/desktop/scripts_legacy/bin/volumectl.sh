#!/bin/sh

VOLUME_REGEX="^(-*|\+*)[0-9]+$"

if [ "$1" == "output" ]; then
    if [[ $2 =~ $VOLUME_REGEX ]]; then
        if [ $(pamixer --get-mute) == "true" ]; then
            pamixer --unmute > /dev/null
        fi
        if [ "${2:0:1}" == "-" ]; then
            pamixer --allow-boost -d "${2:1}" > /dev/null
        elif [ "${2:0:1}" == "+" ]; then
            pamixer --allow-boost -i "${2:1}" > /dev/null
        fi
        volume="$(pamixer --get-volume-human)"
        message="  $volume"
    elif [ $2 == "toggle-mute" ]; then
        if [ $(pamixer --get-mute) == "true" ]; then
            pamixer --unmute > /dev/null
            volume="$(pamixer --get-volume-human)"
            message="  $volume"
        else
            pamixer --mute > /dev/null
            message="󰖁  Silenciado"
        fi
    else
        message="volumectl error: Unknown second argument"
    fi
elif [ "$1" == "input" ]; then
    if [[ $2 =~ $VOLUME_REGEX ]]; then
        if [ $(pamixer --default-source --get-mute) == "true" ]; then
            pamixer --default-source --unmute > /dev/null
        fi
        if [ "${2:0:1}" == "-" ];then
            pamixer --default-source --allow-boost -d "${2:1}" > /dev/null
        elif [ "${2:0:1}" == "+" ]; then
            pamixer --default-source --allow-boost -i "${2:1}" > /dev/null
        fi
        volume="$(pamixer --default-source --get-volume-human)"
        message=" $volume"
    elif [ $2 == "toggle-mute" ]; then
        if [ $(pamixer --default-source --get-mute) == "true" ]; then
            pamixer --default-source --unmute > /dev/null
            volume="$(pamixer --default-source --get-volume-human)"
            message="  $volume"
        else
            pamixer --default-source --mute > /dev/null
            message="  Silenciado"
        fi
    else
        message="volumectl error: Unknown second argument"
    fi
elif [ "$1" == "mpd" ]; then
    if [[ $2 =~ $VOLUME_REGEX ]]; then
        mpc volume $2 > /dev/null
        icon="󰝚"
        volume="$(perl -e "print ('$(mpc 2>/dev/null)' =~ /volume:[ ]*([0-9]*%)/);")"
        if [ "$volume" == "0%" ]; then
            icon="󰝛"
            volume="Silenciado"
        fi
        message="$icon  $volume"
    else
        message="volumectl error: Unknown second argument"
    fi
else
    message="volumectl error: Unknown first argument"
fi

volume=$(echo $volume | tr -d "%")

dunstify --appname "volumectl" --replace 9001 --urgency low --timeout 1250 --hints int:value:$volume "$message"
