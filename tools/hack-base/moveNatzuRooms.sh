#!/usr/bin/bash

# After removing the ability for tilesets to set the "layout group" variable in
# hack-base, instead allowing it to be overridden only in specific cases, I
# noticed that the "seasons" used by the animal companions don't match up with
# normal season values. Normally "summer" would use "room01XX.bin", but in this
# case "summer" (ricky) actually used "room00XX.bin".
#
# So, it's a bit ugly, but I wrote this script to rearrange the room .bin files
# so that they would work properly even without the "layout group" property in
# tileset definitions.

rooms=(46 47 48 49 4a 4b 4c 56 57 58 59 5a 5b 5c 69 6a 6b 6c 79 7a 7b)

function move
{
    folder="rooms/seasons/small/"
    git mv "$folder/room0$1.bin" "$folder/room0$2.bin"
}

for r in ${rooms[@]}; do
    move 3$r 5$r
    move 2$r 3$r
    move 1$r 2$r
    move 0$r 1$r
    move 5$r 0$r
done
