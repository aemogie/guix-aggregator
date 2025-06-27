#!/bin/sh
# SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
#
# SPDX-License-Identifier: CC0-1.0

TIMESTAMP="$(date +%Y%m%d)"
DEST="livecd-$TIMESTAMP"

pushd dist
for image in *.iso
do
    mkdir --verbose --parents $DEST
    mv --verbose $image $DEST/

    pushd $DEST
    sha256sum $image > $image.sha256
    gpg --verbose --armor --detach-sign $image
    popd

    tar cvaf $DEST.tar.zst $DEST
done
popd
