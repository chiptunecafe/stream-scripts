#!/bin/bash

# config
font="/home/max/.local/share/fonts/Eina01-SemiBold.ttf"
font_size="100"
title_width="550"
artist_width="650"

# fuck
width_regex="width: (\S+);"
rendered_title_width="0"
rendered_artist_width="0"
function metadata_widths() {
    im_res=$(convert -debug annotate xc: -font $font -pointsize $font_size -annotate 0 "$1" null: 2>&1)
    if [[ $im_res =~ $width_regex ]]
    then
        rendered_title_width=${BASH_REMATCH[1]}
    fi

    im_res=$(convert -debug annotate xc: -font $font -pointsize $font_size -annotate 0 "$2" null: 2>&1)
    if [[ $im_res =~ $width_regex ]]
    then
        rendered_artist_width=${BASH_REMATCH[1]}
    fi
}

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
metadata_widths "$title" "$artist"

# write metadata to appropriate files
if (( $(echo "$rendered_title_width > $title_width" | bc -l) ))
then
    echo $title"  -  " > ./title_scroll
    echo "" > ./title
else
    echo $title > ./title
    echo "" > ./title_scroll
fi

if (( $(echo "$rendered_artist_width > $artist_width" | bc -l) ))
then
    echo $artist"  -  " > ./artist_scroll
    echo "" > ./artist
else
    echo $artist > ./artist
    echo "" > ./artist_scroll
fi
