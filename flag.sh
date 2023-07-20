#!/usr/bin/env bash

# Bad bash script that generates a flag from the center color of an input image
#
if [ $# -ne 3 ]; then
  echo "Usage: flag.sh INPUT_FILE NUMBER_OF_STRIPES OUTPUT_FILE" >&2
  exit 1
fi

INPUT_FILE=$1

HEIGHT=$(magick $INPUT_FILE -format %h info:)
WIDTH=$(magick $INPUT_FILE -format %w info:)
CENTER_WIDTH=$(($WIDTH/2))

if [ "$2" -gt "$HEIGHT" ]; then
  echo "Height bigger than image height" >&2
  exit 1
fi

echo "Generating a $WIDTH"x"$HEIGHT pixel image"
CMD="-size $WIDTH""x$HEIGHT xc:none"
PIXELS=""
RECTS=""

for STRIPES in $(seq 0 $(($2-1)))
do
	START_HEIGHT=$(( ($STRIPES)*($HEIGHT/$2) ))
	CENTER_HEIGHT=$(($START_HEIGHT+(($HEIGHT/$2)/2)))

  PIXELS="$PIXELS%[hex:p{$CENTER_WIDTH,$CENTER_HEIGHT}]:"	
done

COLORS=$(magick $INPUT_FILE -format $PIXELS info:)
IFS=':' read -r -a COLOR_ARRAY <<< "$COLORS"

for STRIPES in $(seq 0 $(($2-1)))
do

	START_HEIGHT=$(( ($STRIPES)*($HEIGHT/$2) ))
	END_HEIGHT=$(( ($STRIPES+1)*($HEIGHT/$2) ))
  CMD="$CMD -fill \"#${COLOR_ARRAY[STRIPES]}\" -draw \"rectangle 0,$START_HEIGHT $WIDTH,$END_HEIGHT\"" #Drawing a stripe from $START_HEIGHT to $END_HEIGHT with the color taken from the center
done

eval convert $CMD $3
