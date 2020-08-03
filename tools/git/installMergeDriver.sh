#!/bin/bash
git config merge.oracles-bytewise.name "Bytewise merge driver for oracles-disasm"
git config merge.oracles-bytewise.driver "oraclesMergeDriver.py --bytewise %A %O %B %P"

driver=tools/git/oraclesMergeDriver.py
dest=/usr/local/bin/oraclesMergeDriver.py

if ! cp "$driver" "$dest"; then
    echo "Need elevated permissions to copy merge driver to /usr/local/bin."
    sudo cp "$driver" "$dest"
fi

if [[ $? == 0 ]]; then
    echo "Installed oracles merge driver to /usr/local/bin."
else
    echo "Error installing the oracles merge driver."
fi
