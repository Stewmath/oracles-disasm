# About

This is intended to be a full disassembly of Oracle of Ages and Seasons for the Gameboy
Color. When combined with [LynnaLab](https://github.com/drenn1/lynnalab), it is a level
editing suite.

[See the wiki](https://wiki.zeldahacking.net/oracle/Setting_up_ages-disasm) for detailed
setup instructions.


# Required tools to build

* Python 2
* [WLA-DX](https://github.com/vhelin/wla-dx) (A recent build is required)
** For Seasons to build properly, use [this branch](https://github.com/Drenn1/wla-dx/tree/emptyfill-banknumber). Otherwise, empty space won't be filled with the correct values (but the game will still work).
* [Cygwin](http://cygwin.com/install.html) (Only required for windows users)


# Build instructions

Once the dependencies are installed, running `make` will build both games. To build
a specific game, run `make ages` or `make seasons`.

By default, the rom is built with precompressed assets, so that an exact copy of the
original game is produced. In order to edit text, graphics, and other things, run the
"swapbuild.sh" script. This will switch the build mode to "modifiable" instead of
"precompressed".

There are 4 build directories, which are dynamically renamed and symlinked depending on
which game is being built and what the build mode is.

[See the wiki](https://wiki.zeldahacking.net/oracle/Setting_up_ages-disasm) for detailed
setup instructions.


## Tools needed to generate documentation

Type "make doc" to generate documentation, which may or may not work at this point.

* Perl
* Doxygen
* Graphviz for call graphs
