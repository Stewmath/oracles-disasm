#!/bin/sh

# Change the build mode from "vanilla" (exact copy) to fully modifiable, or
# vice versa.

if grep -q 'BUILD_VANILLA = true' Makefile; then
    echo "Switching to modifiable (non-precompressed) mode"

    sed -i 's/BUILD_VANILLA = true/BUILD_VANILLA = false/' Makefile

    [ -f build/no_use_precompressed ] && exit 0
    [ ! -d build_e ] && mkdir -v build_e && touch build_e/no_use_precompressed
    [ -d build_v ] \
        && echo "ERROR: Folder 'build_v' exists already, not swapping build mode" \
        && exit 1

    [ ! -d build ] && mkdir -v build && touch build/use_precompressed

    mv -v build build_v
    mv -v build_e build
    rm -v rom.gbc
elif grep -q 'BUILD_VANILLA = false' Makefile; then
    echo "Switching to precompressed mode"

    sed -i 's/BUILD_VANILLA = false/BUILD_VANILLA = true/' Makefile

    [ -f build/use_precompressed ] && exit 0
    [ ! -d build_v ] && mkdir -v build_v && touch build_v/use_precompressed
    [ -d build_e ] \
        && echo "ERROR: Folder 'build_e' exists already, not swapping build mode" \
        && exit 1

    [ ! -d build ] && mkdir -v build && touch build/no_use_precompressed

    mv -v build build_e
    mv -v build_v build
    rm -v rom.gbc
else
    echo "ERROR: Could not find 'BUILD_VANILLA' setting in the Makefile"
    exit 1
fi

exit 0
