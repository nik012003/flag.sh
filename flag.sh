#!/usr/bin/env bash

# Bad bash script that generates a flag from the center color of an input image
# Usage: flag.sh INPUT_FILE NUMBER_OF_STRIPES OUTPUT_FILE

INPUT_FILE=$1

HEIGHT=$(magick $INPUT_FILE -format %h info:)
WIDTH=$(magick $INPUT_FILE -format %w info:)
CENTER_WIDTH=$(($WIDTH/2))

echo "Generating a $WIDTH"x"$HEIGHT pixel image"
CMD="-size $WIDTH""x$HEIGHT xc:none"

for STRIPES in $(seq 0 $(($2-1)))
do
	START_HEIGHT=$(( ($STRIPES)*($HEIGHT/$2) ))
	END_HEIGHT=$(( ($STRIPES+1)*($HEIGHT/$2) ))
	CENTER_HEIGHT=$(($START_HEIGHT+(($HEIGHT/$2)/2)))
	COLOR=$(magick $INPUT_FILE -format "%[hex:p{$CENTER_WIDTH,$CENTER_HEIGHT}]" info:)
	#Drawing a stripe from $START_HEIGHT to $END_HEIGHT with the color taken from the center
	CMD="$CMD -fill \"#$COLOR\" -draw \"rectangle 0,$START_HEIGHT $WIDTH,$END_HEIGHT\""
done
eval convert $CMD $3
