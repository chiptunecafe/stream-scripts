#!/bin/bash

# kill lingering mpv instance
kill $(cat ./mpv_pid)

# start mpv
mpv \
    --ao=jack \
    --audio-channels=stereo \
    --jack-name=jam_mpv \
    --jack-connect=no \
    --input-ipc-server=./mpv_ipc \
    --audio-stream-silence=yes \
    --no-video \
    --no-terminal \
    --pause \
    "$1" &
echo -n $! > mpv_pid

# wait for mpv to start (more reliable method?)
sleep 1

# make jack connections
jack_connect jam_mpv:out_0 jam_music:in_1
jack_connect jam_mpv:out_1 jam_music:in_2

jack_connect jam_mpv:out_0 system:playback_1
jack_connect jam_mpv:out_1 system:playback_2

jack_connect jam_mpv:out_0 "PulseAudio JACK Source:front-left"
jack_connect jam_mpv:out_1 "PulseAudio JACK Source:front-right"

# read metadata from mpd
title=$(echo '{ "command": ["get_property", "metadata/by-key/title"] }' | socat - ./mpv_ipc | jq -r .data)
artist=$(echo '{ "command": ["get_property", "metadata/by-key/artist"] }' | socat - ./mpv_ipc | jq -r .data)

# compute width of metadata text
rendered_title_width=$(./calculate_width.sh "$title")
rendered_artist_width=$(./calculate_width.sh "$artist")
space_width=$font_size # FIXME hardcoded for monospace

# write metadata to appropriate files
if (( $(echo "$rendered_title_width > $title_width" | bc -l) ))
then
    echo $title" - " > ./title_scroll
    echo "" > ./title
else
    if [ "$center" == "1" ]
    then
        whitespace=$(expr $title_width - $rendered_title_width | tr -d '\n')
        spaces=$(expr $whitespace / 2 / $space_width | tr -d '\n')
        echo "$(head -c $spaces < /dev/zero | tr '\0' ' ')" $title > ./title
    else
        echo $title > ./title
    fi

    echo "" > ./title_scroll
fi

if (( $(echo "$rendered_artist_width > $artist_width" | bc -l) ))
then
    echo $artist" - " > ./artist_scroll
    echo "" > ./artist
else
    if [ "$center" == "1" ]
    then
        whitespace=$(expr $artist_width - $rendered_artist_width | tr -d '\n')
        spaces=$(expr $whitespace / 2 / $space_width | tr -d '\n')
        echo "$(head -c $spaces < /dev/zero | tr '\0' ' ')" $artist > ./artist
    else
        echo $artist > ./artist
    fi

    echo "" > ./artist_scroll
fi
