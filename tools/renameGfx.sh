#!/bin/bash

oldname=$1
newname=$2

files="data/*.s"

for f in $files
do
	sed -i s/$oldname/$newname/ $f
done

[ -f gfx/$oldname\.bin ] && mv gfx/$oldname\.bin gfx/$newname\.bin
[ -f gfx_compressible/$oldname\.bin ] && mv gfx_compressible/$oldname\.bin gfx_compressible/$newname\.bin
[ -f gfx_precompressed/$oldname\.cmp ] && mv gfx_precompressed/$oldname\.cmp gfx_precompressed/$newname\.cmp
