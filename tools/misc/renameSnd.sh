#!/bin/bash
#
# Renames a sound name. Using this to move away from labels like "soundaf" to
# instead replace them with meaningful names, allowing them to be merged between
# games more easily.

if [[ $# < 3 ]]; then
    echo "Usage: $0 <ages|seasons|both> oldname newname"

    exit 1
fi

game=$1
oldname=$2
newname=$3

if [[ "$game" == "both" ]]; then
	files="audio/ages/*.s audio/seasons/*.s audio/mus/common/*.s audio/mus/ages/*.s audio/mus/seasons/*.s audio/sfx/common/*.s audio/sfx/ages/*.s audio/sfx/seasons/*.s" 
elif [[ "$game" == "seasons" ]]; then
	files="audio/seasons/*.s audio/mus/seasons/*.s audio/sfx/seasons/*.s" 
elif [[ "$game" == "ages" ]]; then
	files="audio/ages/*.s audio/mus/ages/*.s audio/sfx/ages/*.s" 
else
	echo "Invalid game."
	exit 1
fi

for f in $files
do
	sed -i "s/\\<$oldname/$newname/" $f
done
