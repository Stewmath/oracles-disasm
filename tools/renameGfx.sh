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

function replace {
    game=$1

    [ -f gfx/$game/$oldname\.bin ] && \
        git mv gfx/$game/$oldname\.bin gfx/$game/$newname\.bin

    [ -f gfx_compressible/$game/$oldname\.bin ] && \
        git mv gfx_compressible/$game/$oldname\.bin gfx_compressible/$game/$newname\.bin

    [ -f precompressed/gfx_compressible/$game/$oldname\.cmp ] && \
        git mv precompressed/gfx_compressible/$game/$oldname\.cmp precompressed/gfx_compressible/$game/$newname\.cmp
}

replace
replace ages
replace seasons
