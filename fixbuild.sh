#!/bin/sh

# Check which build mode the makefile uses, and rearrange the build directories 
# accordingly.

# Copy this to .git/hooks/post-checkout to make sure your build directories are 
# managed automatically.

if grep -q 'BUILD_VANILLA\s*=\s*true' Makefile; then
    [ ! -f build/no_use_precompressed ] && exit 0

    echo "Build mode change detected, switching to precompressed mode"

    [ -d build_e ] \
        && echo "ERROR: Folder 'build_e' exists already, not fixing build mode" \
        && exit 1

    [ ! -d build_v ] && mkdir -v build_v
    mv -v build build_e
    mv -v build_v build
else
    [ ! -f build/use_precompressed ] && exit 0

    echo "Build mode change detected, switching to modifiable mode"

    [ -d build_v ] \
        && echo "ERROR: Folder 'build_v' exists already, not fixing build mode" \
        && exit 1

    [ ! -d build_e ] && mkdir -v build_e
    mv -v build build_v
    mv -v build_e build
fi
