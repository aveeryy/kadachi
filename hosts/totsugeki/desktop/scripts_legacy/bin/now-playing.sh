#!/bin/bash

RPC_HOST=http://localhost:6680/mopidy/rpc
TRACK=$(curl -s -X POST -H Content-Type:application/json -d '{ "method": "core.playback.get_current_track", "jsonrpc": "2.0", "params": {}, "id": 1 }' $RPC_HOST)
TRACK_URI=$(echo $TRACK | jq -r '.result.uri')
IMAGES=$(curl -s -X POST -H Content-Type:application/json -d '{  "method": "core.library.get_images", "jsonrpc": "2.0", "params": { "uris": ["'"$TRACK_URI"'"] },  "id": 1}' $RPC_HOST)
IMAGE_URI=$(echo $IMAGES | jq -r 'first(.result[] | sort_by(.width) | reverse | .[].uri)')
if [[ -n "$IMAGE_URI" ]]; then
    if [[ "$IMAGE_URI" == *"local/"* ]]; then
      # Image is local
      IMAGE="$HOME/.local/share/mopidy/local/images${IMAGE_URI/local\//}"
    else 
      curl -o /tmp/cover.png $IMAGE_URI &> /dev/null
      IMAGE="/tmp/cover.png"
    fi
fi

dunstify -r 99902 -I $IMAGE "Reproduciendo" "$(mpc --format '<b>%artist% - %album%</b>\n%title%' current 2> /dev/null)"
