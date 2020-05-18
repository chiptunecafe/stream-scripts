#!/bin/bash

# load config
source "$2"

remaining=$(find "$1" ! -path "$1" | wc -l)

while read -u 3 song
do
    ((remaining=remaining-1))
    echo Queueing $song... \($remaining remain\)

    ./queue.sh "$song"

    echo "Press [ENTER] to play"
    read

    ./start.sh

    echo "Press [ENTER] to move on to next song"
    read
done 3< <(find "$1" ! -path "$1" | shuf --random-source=/dev/urandom)

./dequeue.sh
