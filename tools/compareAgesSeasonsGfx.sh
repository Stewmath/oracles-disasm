#!/bin/bash
#
# This compares ages's and season's compressible graphics files, and moves any matching
# files into the common directory for both games. (It uses the ages filename.)

for sf in gfx_compressible/seasons/*.bin; do
    for af in gfx_compressible/ages/*.bin; do

        if diff "$sf" "$af" >/dev/null; then
            echo "$sf = $af. Merging."

            # Get filename without directory or extension
            basenameA=$(basename $af | sed 's/\..*//')
            basenameS=$(basename $sf | sed 's/\..*//')

            # Check if the ages filename exists in seasons as well. That's a problem, it
            # needs to be resolved manually (rename one of them before proceeding).
            if [[ -f "gfx_compressible/seasons/$basenameA.bin" ]]; then
                echo "ERROR: $basenameA.bin exists in seasons already. Rename one of them."
                exit 1
            fi

            git mv "$af" "gfx_compressible/$basenameA.bin"
            git rm "$sf"

            git mv "precompressed/gfx_compressible/ages/$basenameA.cmp" \
                "precompressed/gfx_compressible/$basenameA.cmp"
            git rm "precompressed/gfx_compressible/seasons/$basenameS.cmp"

            tools/renameGfx.sh $basenameS $basenameA seasons

            break
        fi

    done
done
