#!/usr/bin/env python3
#
# Used this script to modify the format of gfx .cmp files, adding 2 bytes for
# the decompressed length.

import sys, os
from pathlib import Path

sys.path.append(os.path.dirname(__file__) + '/..')
from common import *

def reformatFile(filename):
    print(filename)
    f = open(filename, 'rb')
    data = f.read()
    f.close()

    mode = data[0]
    data = data[1:]

    decompressed = decompressGfxData(data, 0, 1000000, mode)[1]
    length = len(decompressed)

    assert(length < 0x10000)

    f = open(filename, 'wb')
    f.write(bytes([mode, length & 0xff, (length >> 8) & 0xff]))
    f.write(data)
    f.close()

path = Path('precompressed/gfx_compressible/')
for file_path in path.rglob('*'):
    if file_path.is_file():
        reformatFile(str(file_path))
