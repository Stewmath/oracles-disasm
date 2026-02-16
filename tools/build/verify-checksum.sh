#!/bin/bash
GAME=$1
REGION=$2

# Construct the filename: game_region (e.g., seasons_us, ages_jp)
FILENAME="${GAME}_${REGION}"

echo "Comparing to vanilla ROM MD5 checksum..."
md5sum -c ${FILENAME}.md5 2>/dev/null
