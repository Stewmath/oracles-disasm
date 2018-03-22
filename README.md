# About

This is intended to be a full disassembly of Oracle of Ages for the Gameboy
Color. When combined with [LynnaLab](https://github.com/drenn1/lynnalab), it is 
a level editing suite.

Most code is located in main.s, but most of it should migrate to separate files
in the "code" folder eventually.

[Visit the wiki](http://wiki.zeldahacking.net) for more information.

Seasons doesn't work yet.

# Required tools to build

* Python 2
* [WLA-DX](https://github.com/vhelin/wla-dx) (a recent build)
* [Cygwin](http://cygwin.com/install.html) (Only required for windows users)

## Tools needed to generate documentation

Type "make doc" to generate documentation.

* Perl
* Doxygen
* Graphviz for call graphs

# A note about compression

A nice bit of progress I've made is the ability to de and re-compress all of the 
game's compressed text and graphics. However my compression algorithms don't 
match up 1:1 with the compression Capcom used. So, in order to be able to 
continue building a 1:1 rom, by default it is built with "precompressed" 
text/graphics. In order to make modifications to the graphics in the 
"gfx\_compressible" folder, and the file "text/text.txt", you must disable the 
corresponding option in the Makefile.
