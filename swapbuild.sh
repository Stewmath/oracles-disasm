#!/bin/bash

# Change the build mode from "vanilla" (exact copy) to fully modifiable, or
# vice versa.

if [[ -d build_e ]]; then
        mv build build_v
        mv build_e build
        sed -i 's/BUILD_VANILLA = false/BUILD_VANILLA = true/' Makefile
else
        mv build build_e
        mv build_v build
        sed -i 's/BUILD_VANILLA = true/BUILD_VANILLA = false/' Makefile
fi
