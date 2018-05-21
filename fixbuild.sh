#!/bin/bash

# Check which build mode the makefile uses, and rearrange the build directories 
# accordingly.

# Copy this to .git/hooks/post-checkout to make sure your build directories are 
# managed automatically.

function to_precmp {
    folder='build_'$1
    v=$folder\_v
    e=$folder\_e

    [ -d $e ] \
        && echo "ERROR: Folder '$e' exists already, not fixing build mode" \
        && exit 1

    [ ! -d $v ] && mkdir -v $v
    mv -v $folder $e
    mv -v $v $folder
}

function to_modifiable {
    folder='build_'$1
    v=$folder\_v
    e=$folder\_e

    [ -d $v ] \
        && echo "ERROR: Folder '$v' exists already, not fixing build mode" \
        && exit 1

    [ ! -d $e ] && mkdir -v $e
    mv -v $folder $v
    mv -v $e $folder
}

if grep -q 'BUILD_VANILLA\s*=\s*true' Makefile; then
    [ ! -f build/no_use_precompressed ] && exit 0

    echo "Build mode change detected, switching to precompressed mode"

    to_precmp 'ages'
    to_precmp 'seasons'
else
    [ ! -f build/use_precompressed ] && exit 0

    echo "Build mode change detected, switching to modifiable mode"

    to_modifiable 'ages'
    to_modifiable 'seasons'
fi
