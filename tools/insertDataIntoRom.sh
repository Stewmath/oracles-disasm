#!/bin/bash
if [[ $# < 1 ]]; then
	echo "Usage: $0 destfile"
	echo
	echo "Run this script from the root of the disassembly repository."
	echo "Ensure that the build mode is set to 'modifiable', not 'precompressed' (run swapbuild.sh if in doubt)"
	echo
	echo "This will insert various changes from the disassembly into another rom, including:"
	echo "- Compressed graphics (everything in gfx_compressible/)"
	echo "- Gfx headers (data/gfxHeaders.s, data/npcGfxHeaders.s, data/uniqueGfxHeaders.s)"
	echo "- Text (text/text.txt)"
	echo "Addresses 0xe2aec-0xe3fff are free space in the ages rom, but will be"
	echo "overwritten by this script in case of growing graphics/text data."
	echo
        echo "This will currently only work with zole-modded roms. Anything else will get their"
        echo "room layouts corrupted."
        echo
	echo "Always make backups..."
	exit 1
fi

outfile=$1

# Find a label's address from the sym file (not used)
function getval() {
	val=$(awk -v name="$1" -F'[: ]' '$3 == name {print "0x"$1"*0x4000+0x"$2}' rom.sym)
	val=$(($val-0x4000))
}

function insert() {
	dd bs=1 if=rom.gbc of="$outfile" skip=$1 seek=$1 count=$(($2-$1)) conv=notrunc 2>/dev/null
}

[[ ! -f $outfile ]] \
    && echo "\"$outfile\" is not a file." \
    && exit 1

# Rebuild with FORCE_SECTIONS defined.
# This should keep the addresses the same as the vanilla rom, provided nothing was
# altered too drastically.
rm build/main.o
FORCE_SECTIONS=1 make

[[ $? != 0 ]] && exit 1

echo "Copying graphics and text..."
# Graphics and text
insert $((0x1d*0x4000)) $((0x39*0x4000))

echo "Copying pointers..."
# Gfx headers
insert $((0x69da)) $((0x7870))
# Npc gfx headers
insert $((0xfda8a)) $((0xfdd4b))
# Unique gfx headers
insert $((0x119d0)) $((0x11b52))
# Text offset pointers
insert $((0xfcfb3)) $((0xfcff5))

echo "Done."
