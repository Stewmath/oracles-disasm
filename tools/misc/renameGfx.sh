#!/bin/bash
#
# Renames a file in gfx/ gfx_compressible/.
#
# Note: this replaces files in both the ages and seasons subdirectories. This means that
# files with the same name should have the same meaning, because they will be renamed
# together. The raw dumps had at least one "collision" where the two different files had
# the same name (since they were based on their source addresses), but that's been dealt
# with.

if [[ $# < 2 ]]; then
    echo "Usage: $0 oldname newname"

    exit 1
fi

oldname=$1
newname=$2

files="data/*.s data/ages/*.s data/seasons/*.s"

for f in $files
do
	sed -i "s/\\<$oldname\\>/$newname/" $f
done

function try_replace {
    old=$1/$2
    new=$1/$3

    [ -f $old.bin ] && \
        git mv $old.bin $new.bin
    [ -f $old.cmp ] && \
        git mv $old.cmp $new.cmp
    [ -f $old.png ] && \
        git mv $old.png $new.png
    [ -f $old.properties ] && \
        git mv $old.properties $new.properties
}

function replace {
    game=$1

    try_replace gfx/$game $oldname $newname
    try_replace gfx_compressible/$game $oldname $newname
    try_replace precompressed/gfx_compressible/$game $oldname $newname
    try_replace test/gfx_compressible/$game $oldname $newname
}

replace
replace ages
replace seasons
