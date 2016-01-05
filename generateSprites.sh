#!/bin/bash
# aparra
# Generate set's of differents sizes png's. Mac os x
# ./generateSprites input_folder output_folder
# input format: dir/dir/name (number).png/jpg/gif
# output:
# output_folder.multi\32x32\dir\name\number.png --> Zero padding
#                    \64x64\dir\name\number.png
#
# In linux is needed the imageMagick utility "convert"
 
#sizes 16 32 64 128 256 512 ...
sizes=(64 32)
#outputdir
dirout=$2.multi
#padding
padtowidth=4
#system
system="mac"

mkdir -p $dirout

find $1 \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -print0 | \
while read -d $'\0' -r image; do
  echo $image #$w $h 
  filename="${image##*/}"
  ext="${filename##*.}"
  dir="${image%%\ (*}"
  number="${filename##*(}"
  number="${number%)*}"
  printf -v number "%0${padtowidth}d" $number
  i=0
  while [ $i -lt ${#sizes[@]} ]; do
	base=${number}.$ext
	diroutmulti=$dirout/${sizes[$i]}x${sizes[$i]}/$dir
	mkdir -p "$diroutmulti" && cp "$image" "$diroutmulti/$base"
	if [ "$system" = "mac" ]; then
            sips -z ${sizes[$i]} ${sizes[$i]} $diroutmulti/$base &>/dev/null
    else
            convert $diroutmulti/$base -resize ${sizes[$i]}x${sizes[$i]} $diroutmulti/$base &>/dev/null
    fi
	: $[ i++ ]
  done
done


