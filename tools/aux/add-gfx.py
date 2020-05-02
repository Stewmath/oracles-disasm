import os
from common import *

for i in range(0,0x80):
    name = 'tilelayouts/ages/tilesetCollisions%s.bin' % myhex(i,2)
    if not os.path.exists(name):
        data = bytearray([0] * 256)
        f = open(name, 'wb')
        f.write(data)
        f.close()
