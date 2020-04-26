#!/bin/bash

# Change the build mode from "vanilla" (exact copy) to fully modifiable, or
# vice versa.

if grep -q 'BUILD_VANILLA = true' Makefile; then
    echo "Switching to modifiable (non-precompressed) mode"

    sed -i 's/BUILD_VANILLA = true/BUILD_VANILLA = false/' Makefile

elif grep -q 'BUILD_VANILLA = false' Makefile; then
    echo "Switching to precompressed mode"

    sed -i 's/BUILD_VANILLA = false/BUILD_VANILLA = true/' Makefile

else
    echo "ERROR: Could not find 'BUILD_VANILLA' setting in the Makefile"
    exit 1
fi

exit 0
