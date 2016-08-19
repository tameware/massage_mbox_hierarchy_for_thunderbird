#! /bin/bash

## PURPOSE:     Update a Eudora-style directory hierarchy of mailboxes so that
#               it can be placed in Thunderbird's "Local Folders" directory.
#               The hierarchy is updated in-place.

## USAGE:       $0 "Mail Folder"

## AUTHOR:      Adam Wildavsky <adam@tameware.com>

## DATE:        2016-08-18

# -depth        So that we don't rename a directory before processing its children.
# -mindepth 1   So that we ignore the root folder, which is normally the
#               Eudora Mail Folder itself.
# -type d       Only directories
# -print0       Required so that we can deal with directories with spaces
#               in their names
#
#               The pipe to "read" is a trick I picked up on Stack Overflow.

find "$1" -depth -mindepth 1 -type d -print0 | while IFS= read -r -d '' DIR; do
    # Remove a trailing slash, if any
    DIR=`echo $DIR | sed -e 's-/$--'`

    # Don't process directories that are already named correctly;
    # This makes the script idempotent.
    if ! [[ $DIR =~ sbd$ ]]; then
        echo Processing "$DIR" …
        # Thunderbird requires directories containing mailboxes to have a
        # .sbd extension
        mv "$DIR" "$DIR".sbd
        # Thunderbird requires an empty file with the same name as $DIR
        touch "$DIR"
    fi
done
