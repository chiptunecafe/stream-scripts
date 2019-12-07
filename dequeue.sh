#!/bin/bash

# kill mpv
kill $(cat ./mpv_pid)

# write default title and artist
echo -n "---" > ./title
echo -n "---" > ./artist
echo -n "" > ./title_scroll
echo -n "" > ./artist_scroll
