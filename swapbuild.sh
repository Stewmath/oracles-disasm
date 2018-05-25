#!/bin/bash

# Change the build mode from "vanilla" (exact copy) to fully modifiable, or
# vice versa.

function vToE {
    folder='build_'$1
    v=$folder\_v
    e=$folder\_e

    [ -f $folder/no_use_precompressed ] && exit 0
    [ ! -d $e ] && mkdir -v $e && touch $e/no_use_precompressed
    [ -d $v ] \
        && echo "ERROR: Folder '$v' exists already, not swapping build mode" \
        && exit 1

    [ ! -d $folder ] && mkdir -v $folder && touch $folder/use_precompressed

    mv -v $folder $v
    mv -v $e $folder

    rm -v $1.gbc
}

function eToV {
    folder='build_'$1
    v=$folder\_v
    e=$folder\_e

    [ -f $folder/use_precompressed ] && exit 0
    [ ! -d $v ] && mkdir -v $v && touch $v/use_precompressed
    [ -d $e ] \
        && echo "ERROR: Folder '$e' exists already, not swapping build mode" \
        && exit 1

    [ ! -d $folder ] && mkdir -v $folder && touch $folder/no_use_precompressed

    mv -v $folder $e
    mv -v $v $folder

    rm -v $1.gbc
}

if grep -q 'BUILD_VANILLA = true' Makefile; then
    echo "Switching to modifiable (non-precompressed) mode"

    sed -i 's/BUILD_VANILLA = true/BUILD_VANILLA = false/' Makefile

    vToE 'ages'
    vToE 'seasons'

elif grep -q 'BUILD_VANILLA = false' Makefile; then
    echo "Switching to precompressed mode"

    sed -i 's/BUILD_VANILLA = false/BUILD_VANILLA = true/' Makefile

    eToV 'ages'
    eToV 'seasons'
else
    echo "ERROR: Could not find 'BUILD_VANILLA' setting in the Makefile"
    exit 1
fi

exit 0
