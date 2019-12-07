# stream scripts

## dependencies

* jack
* mpv
* socat
* jq
* imagemagick
* gnu parallel (normalize.sh only)
* ffmpeg (normalize.sh only)

## usage

writes metadata to `./title` and `./artist` or `./title_scroll` and `./artist_scroll`

**set queued song:** `./queue.sh /path/to/song`

**start/resume queued song:** `./start.sh`

**pause queued song:** `./pause.sh`

**remove queued song and reset metadata:** `./dequeue.sh`

**normalize audio files:** `./normalize.sh indir outdir`

all scripts are vaguely commented if you need to make changes
