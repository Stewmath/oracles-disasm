# This script parses a wla file and converts my style of local labels into
# something that's compileable. My local labels start with a dot, and fall out
# of scope at the next non-local label.

import sys
import re

if len(sys.argv) < 3:
    print 'Usage: ' + sys.argv[0] + ' asmFile outFile'
    sys.exit()

asmFile = open(sys.argv[1], 'r')
outFile = open(sys.argv[2], 'w')

blockNumber = 0
lineIndex = 0

pendingLabels = []
definedLabels = []
blockLines = []

def checkPendingLabels():
    global definedLabels
    global blockLines
    for line in blockLines:
        if '.' in line:
            for label in definedLabels:
                if label in line:
                    line = re.sub(r'(\s)\.\b' + label + r'\b',
                            r'\1__' + label + '_' + filenameString + '_blockNumber' + str(blockNumber),
                            line,
                            re.X)
        outFile.write(line)

    pendingLabels = []
    definedLabels = []
    blockLines = []

filenameString = re.sub(r'[. ]','_',sys.argv[1])

while True:
    line = asmFile.readline()
    lineIndex+=1
    if line == "":
        break

    if '.ends' in line or '.section' in line or '.ENDS' in line or '.SECTION' in line:
        checkPendingLabels()
        blockNumber+=1
    elif '.' in line or ':' in line:
        # Check for non-local label
        pat = re.compile(r'^\s*[^\.][^\s;]*:')
        if pat.match(line) is not None:
            checkPendingLabels()
            blockNumber+=1
        else:
            # Check for local label
            pat = re.compile(r'^(\s*)\.([^\s;]*?):(\s*(;.*)?$)')
            matchObj = pat.match(line)
            if matchObj is not None:
                if matchObj.group(2) in definedLabels:
                    print 'ERROR: Line ' + str(lineIndex) + ': Label \"' + matchObj.group(2) + '\" defined for a second time.'
                    sys.exit(1)
                definedLabels.append(matchObj.group(2))
                line = pat.sub(r'\1__\2_' + filenameString + '_blockNumber' + str(blockNumber) + ':' + r'\3', line)

    blockLines.append(line)

checkPendingLabels()

asmFile.close()
outFile.close()

sys.exit(0)
