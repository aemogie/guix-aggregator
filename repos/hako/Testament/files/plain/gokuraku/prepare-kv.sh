#!/bin/sh
# SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
#
# SPDX-License-Identifier: CC0-1.0

PATH=/run/current-system/profile/bin

mkdir --parents /var/cache/kv
pushd /var/cache/kv

find /var/cache/guix/narinfo -type f -printf '%P\n' | sort > new.txt

if [ -e old.txt ]; then
    cp --force old.txt old.txt.bak
    diff --unified old.txt new.txt | tail +4 > diff.txt
    grep '^-' diff.txt | sed 's/^-//g' > to-delete.txt
    grep '^+' diff.txt | sed 's/^+//g' > to-copy.txt
    rm --force diff.txt
fi

if [ ! -s to-delete.txt ]; then
    rm --force to-delete.txt
fi
if [ ! -s to-copy.txt ]; then
    rm --force to-copy.txt
fi

popd
