#!/bin/sh
# SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
#
# SPDX-License-Identifier: CC0-1.0

if [ "x$BASH_VERSION" = "x" ]; then
    exec bash "$0" "$@"
fi

msg() {
    echo "INFO: $*"
}

die() {
    echo "ERROR: $*"
    exit 1
}

PATH=/run/current-system/profile/bin
RCLONE_ARGS="\
    --config /run/secrets/rclone \
    --verbose --size-only --no-traverse \
    --s3-no-check-bucket --s3-upload-concurrency=8 --s3-chunk-size=16M"

NARINFO_OLD=/var/cache/r2/narinfo-old.txt
NARINFO_NEW=/var/cache/r2/narinfo-new.txt
NARINFO_DIFF=/var/cache/r2/nar.diff
NARINFO_TO_DELETE=/var/cache/r2/narinfo-to-delete.txt
NARINFO_TO_COPY=/var/cache/r2/narinfo-to-copy.txt

NAR_OLD=/var/cache/r2/nar-old.txt
NAR_NEW=/var/cache/r2/nar-new.txt
NAR_DIFF=/var/cache/r2/narinfo.diff
NAR_TO_DELETE=/var/cache/r2/nar-to-delete.txt
NAR_TO_COPY=/var/cache/r2/nar-to-copy.txt

list_narinfo() {
    msg "listing narinfo changes"

    pushd /var/cache/guix/publish
    fd '\.narinfo$' --type f | sort > $NARINFO_NEW
    popd

    diff --unified $NARINFO_OLD $NARINFO_NEW | tail +4 > $NARINFO_DIFF
    rg '^-'  $NARINFO_DIFF --no-line-number --replace '' > $NARINFO_TO_DELETE
    rg '^\+' $NARINFO_DIFF --no-line-number --replace '' > $NARINFO_TO_COPY
    rm --force $NARINFO_DIFF
}

list_nar() {
    msg "listing nar archive changes"

    pushd /var/cache/guix/publish/nar
    fd --type f --exclude '*.tmp' | sort > $NAR_NEW
    popd

    diff --unified $NAR_OLD $NAR_NEW | tail +4 > $NAR_DIFF
    rg '^-'  $NAR_DIFF --no-line-number --replace '' > $NAR_TO_DELETE
    rg '^\+' $NAR_DIFF --no-line-number --replace '' > $NAR_TO_COPY
    rm --force $NAR_DIFF
}

delete_narinfo() {
    msg "removing expired narinfo files"

    pushd /var/cache/guix-moe/narinfo
    old_IFS=$IFS
    IFS=""
    while read -r file; do
        rm --force "$file"
    done < $NARINFO_TO_DELETE
    IFS=${old_IFS}
    popd
}

copy_narinfo() {
    msg "copying new narinfo files"

    pushd /var/cache/guix/publish
    old_IFS=$IFS
    IFS=""
    while read -r file; do
        if [[ -e $file ]]; then
            echo "
                (use-modules (ice-9 match)
                             (web uri)
                             (guix records))

                (call-with-output-file \"/var/cache/guix-moe/narinfo/$file\"
                  (lambda (port)
                    (for-each
                     (match-lambda
                       ((field . value)
                        (if (string=? field \"URL\")
                            (format port \"~a: ~a~%\" field (uri-decode value))
                            (format port \"~a: ~a~%\" field value))))
                     (call-with-input-file \"$file\" recutils->alist))))
            " | guix repl -t machine
        fi
    done < $NARINFO_TO_COPY
    IFS=${old_IFS}
    popd
}

delete_nar() {
    msg "removing expired nar archives from Cloudfare R2"

    if [[ -s $NAR_TO_DELETE ]]; then
        rclone delete $RCLONE_ARGS --files-from $NAR_TO_DELETE r2:substitutes-apac/nar
    fi
}

upload_nar() {
    msg "uploading new nar archives to Cloudflare R2"

    if [[ -s $NAR_TO_COPY ]]; then
        rclone copy $RCLONE_ARGS --files-from $NAR_TO_COPY /var/cache/guix/publish/nar r2:substitutes-apac/nar
    fi
}

clean_up() {
    msg "cleaning up temporary files"

    rm $NARINFO_TO_DELETE $NARINFO_TO_COPY $NAR_TO_DELETE $NAR_TO_COPY
    mv $NARINFO_NEW $NARINFO_OLD
    mv $NAR_NEW $NAR_OLD
}

main() {
    [[ -e $NARINFO_NEW || -e $NAR_NEW ]] && die "previous syncing process unfinished"

    mkdir --parents /var/cache/r2 /var/cache/guix-moe/narinfo
    touch $NARINFO_OLD $NAR_OLD

    list_narinfo
    list_nar

    set -eo pipefail

    delete_narinfo
    upload_nar
    copy_narinfo
    delete_nar

    clean_up
}

main
