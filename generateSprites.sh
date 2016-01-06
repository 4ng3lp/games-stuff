#!/bin/bash
# aparra
# Generate set's of differents sizes png's. Mac os x
# ./generateSprites input_folder output_folder rename_type
# input format: 
#     rename_type: 0 -> no rename at output
#     rename_type: 1 -> dir/dir/name (number).png/jpg/gif
# output:
# output_folder.multi\32x32\dir\name\number.png --> Zero padding
#                    \64x64\dir\name\number.png
#
# In linux is needed the imageMagick utility "convert"
 
#sizes 16 32 64 128 256 512 ...
sizes=(256 128 64 32)
#outputdir
dirout="$2.multi"
#rename policie
rename_type="$3"
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
  echo "number: " $number
  i=0
  while [ $i -lt ${#sizes[@]} ]; do
  if [ $rename_type = 1 ]; then 
    number="0x${number%)*}"
printf -v number "%0${padtowidth}d" "$number"
  
	 base="${number}.$ext"
	 diroutmulti="$dirout/${sizes[$i]}x${sizes[$i]}/$dir"
   mkdir -p "$diroutmulti"
  else 
    if [ $rename_type = 0 ]; then 
      diroutmulti="$dirout/${sizes[$i]}x${sizes[$i]}"
      mkdir -p "$diroutmulti/$1"
      base="$image";
    fi  
  fi
  echo "$diroutmulti"
	cp "$image" "$diroutmulti/$base"
	if [ "$system" = "mac" ]; then
            sips -z ${sizes[$i]} ${sizes[$i]} $diroutmulti/$base &>/dev/null
    else
            convert $diroutmulti/$base -resize ${sizes[$i]}x${sizes[$i]} $diroutmulti/$base &>/dev/null
    fi
	: $[ i++ ]
  done
done


