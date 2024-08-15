#!/usr/bin/bash

in_dir="$1"
if [ -z "$in_dir" ] || [ ! -d "$in_dir" ]; then
    echo "input dir not found: $in_dir" >&1
    exit 1
fi
out_dir="$2"
if [ -z "$out_dir" ]; then
    out_dir="$HOME/tmp"
fi
if [ ! -d "$out_dir" ]; then
    echo "output dir not found: $out_dir" >&1
    exit 1
fi

# ffmpeg -i input.mp4 -c:v libx265 -vtag hvc1 -c:a copy output.mp4
# Options Explained
# -i input file name or file path
# -c:v libx265 -vtag hvc1 selecting compression. Default is libx264
# -vf scale=1920:1080 specifying output resolution
# -c:a copy copy audio as it is without any compression
# -preset slow ask compression algorithm to take more time & look for more areas for compression. Default is medium. Other options are faster, fast, medium, slow, slower
# -crf 20 Compression quality
# -crf 0 high-quality, low compression, large file
# -crf 23 default
# -crf 51 low-quality, high compression, small file
# -vtag hvc1 use codec hvc1 (a.k.a. HEVC or h.265) during conversion.
# If -vtag isn't specified (like in the first snippet), it will then use the codec used in the src file.
# https://stackoverflow.com/a/69316283

for i in "$in_dir"/*; do
    fn="${i##*/}"
    base="${fn%.*}"
    dst="$out_dir/$base.mkv"
    echo "$fn => $dst..."
    ffmpeg -i "$i" -c:v libx265 -vtag hvc1 -c:a libopus "$dst" || exit $?
    echo "ok"
    ls -lh "$i" "$dst"
    #break
done

