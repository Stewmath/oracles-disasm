#!/bin/bash

if [[ $# < 2 ]]; then
    echo "Usage: $0 oldname newname game"
    echo
    echo "'game' should be either blank, 'ages' or 'seasons'."
    echo "If blank, it will try to rename the 'common' graphics; otherwise it"
    echo "will use the appropriate subdirectories."

    exit 1
fi

oldname=$1
newname=$2
game=$3

files="data/$game/*.s"

for f in $files
do
	sed -i "s/\\<$oldname\\>/$newname/" $f
done

[ -f gfx/$game/$oldname\.bin ] && \
    git mv gfx/$game/$oldname\.bin gfx/$game/$newname\.bin

[ -f gfx_compressible/$game/$oldname\.bin ] && \
    git mv gfx_compressible/$game/$oldname\.bin gfx_compressible/$game/$newname\.bin

[ -f precompressed/gfx_compressible/$game/$oldname\.cmp ] && \
    git mv precompressed/gfx_compressible/$game/$oldname\.cmp precompressed/gfx_compressible/$game/$newname\.cmp
