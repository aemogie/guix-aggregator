#!/bin/sh
# SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
#
# SPDX-License-Identifier: CC0-1.0

PATH=/run/current-system/profile/bin
RCLONE=$1
RCLONE_ARGS="\
    --config /run/secrets/rclone \
    --verbose --size-only --no-traverse \
    --s3-no-check-bucket --s3-upload-concurrency=8 --s3-chunk-size=16M"

mkdir --parents /var/cache/r2
pushd /var/cache/r2
if [ -e new.txt ]; then
    exit 1
else
    find /var/cache/guix/publish/nar -type f -printf '%P\n' | sort > new.txt

    if [ -e old.txt ]; then
        cp --force old.txt old.txt.bak
        diff --unified old.txt new.txt | tail +4 > diff.txt
        grep '^-' diff.txt | sed 's/^-//g' > to-delete.txt
        grep '^+' diff.txt | sed 's/^+//g' > to-copy.txt
        rm --force diff.txt
    fi
    if [ -s to-delete.txt ]; then
        $RCLONE delete $RCLONE_ARGS --files-from to-delete.txt r2:substitutes-apac/nar
    fi
    if [ -s to-copy.txt ]; then
        $RCLONE copy   $RCLONE_ARGS --files-from to-copy.txt /var/cache/guix/publish/nar r2:substitutes-apac/nar
    fi

    rm --force to-delete.txt to-copy.txt
    mv new.txt old.txt
fi
popd
