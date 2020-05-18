#!/bin/bash

width_regex="width: (\S+);"
im_res=$(convert -debug annotate xc: -font "$font" -pointsize $font_size -annotate 0 "$1" null: 2>&1)
if [[ $im_res =~ $width_regex ]]
then
    echo -n ${BASH_REMATCH[1]}
fi
