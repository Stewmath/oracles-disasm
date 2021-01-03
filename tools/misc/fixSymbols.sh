# As of BGB 1.5.8, symbol files output by WLA don't work.
#
# Using the "-S" flag outputs definitions in a separate section from labels. This should work fine,
# but BGB is now failing to read it properly.
#
# Using the "-s" flag outputs nocash style symbol files. This *should* work, but WLA v9.11 is
# outputting defines into the symbol file, which it should not be doing... so the same problem
# happens!
#
# Not only do the definitions make the debugger unreadable, but if there is any definition with
# a value of $10000 or higher, BGB will refuse to load the symbol file entirely!
#
# So just delete the whole damned section. When the next release of WLA is made, the nocash symbol
# file will stop outputting definitions, so I can switch to using that. Alternatively, perhaps the
# next release of BGB will fix the issue.

sed -i '1,/^\[definitions\]$/!d' $1
