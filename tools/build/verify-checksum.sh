#!/bin/bash
echo "Comparing to vanilla ROM MD5 checksum..."
if [[ "$1" == "seasons" ]]; then
	md5sum -c $1.md5 2>/dev/null
	if [[ $? -ne 0 ]]; then
		echo "Trying $1_emptyfill_0.md5..."
		md5sum -c $1_emptyfill_0.md5 2>/dev/null
	fi
else
	md5sum -c $1.md5 2>/dev/null
fi
