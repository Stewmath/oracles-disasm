#!/usr/bin/python3
# Handles merge conflicts between certain types of binary files.

import sys

if len(sys.argv) < 5:
    print("This is a git merge driver for oracles-disasm. Install it with 'tools/git/installMergeDriver.sh'.")
    sys.exit(1)


# Bytewise: As long as the same byte is not modified in both versions, the merge is allowed to occur.
if sys.argv[1] == "--bytewise":
    currentVersionFilename = sys.argv[2]
    ancestorFilename = sys.argv[3]
    branchFilename = sys.argv[4]

    def grabData(filename):
        f = open(filename, 'rb')
        d = f.read()
        f.close()
        return bytearray(d)

    cv = grabData(currentVersionFilename)
    av = grabData(ancestorFilename)
    bv = grabData(branchFilename)

    if not (len(cv) == len(av) and len(cv) == len(bv)):
        sys.exit(1)

    for i in range(len(cv)):
        a = av[i]
        if cv[i] != a and bv[i] != a and cv[i] != bv[i]: # Fail if this byte was changed in different ways
            sys.exit(1)
        if cv[i] != a:
            av[i] = cv[i]
        else:
            av[i] = bv[i]

    f = open(currentVersionFilename, 'wb')
    f.write(av)
    f.close()

    sys.exit(0)

else:
    print(sys.argv[0] + " was invoked incorrectly.")
    sys.exit(1)
