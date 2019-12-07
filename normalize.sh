#!/bin/bash

# loudnorm params
loudnorm="I=-16:TP=-1.5:LRA=11"

# other ffmpeg params
ff_params="-ar 48k"
ff_ext=".flac"

outdir=$2
function normalize() {
    # run 1st ffmpeg pass
    ff_out=$(ffmpeg -i "$1" -af loudnorm=$loudnorm:print_format=json -f null - 2>&1 | tail -n 12)
    
    # extract ffmpeg results
    measured_i=$(echo $ff_out | jq -r .input_i)
    measured_lra=$(echo $ff_out | jq -r .input_lra)
    measured_tp=$(echo $ff_out | jq -r .input_tp)
    measured_thresh=$(echo $ff_out | jq -r .input_thresh)
    offset=$(echo $ff_out | jq -r .target_offset)
    
    # get stripped filename
    filename=$(basename -- "$1")
    filename=${filename%.*}

    # run 2nd ffmpeg pass
    ffmpeg -i "$1" -af loudnorm=$loudnorm:measured_I=$measured_i:measured_LRA=$measured_lra:measured_TP=$measured_tp:measured_thresh=$measured_thresh:offset=$offset:linear=true:print_format=summary $ff_params "${outdir}/${filename}${ff_ext}"
}

# initialize env_parallel
. `which env_parallel.bash`

find $1 ! -path $1 | env_parallel normalize "{}"
