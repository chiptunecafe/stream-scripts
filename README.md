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

### the important command

`./driver.sh path/to/songs config.sh`

`config.sh` should contain:
```sh
export font="absolute/path/to/font"
export font_size="size of text on stream"
export title_width="width of title textbox on stream"
export artist_width="width of artist textbox on stream"
export center=0 or 1
```

### internals (can be used for manual control)

**set queued song:** `./queue.sh /path/to/song`

**start/resume queued song:** `./start.sh`

**pause queued song:** `./pause.sh`

**remove queued song and reset metadata:** `./dequeue.sh`

**normalize audio files:** `./normalize.sh indir outdir`

all scripts are vaguely commented if you need to make changes
