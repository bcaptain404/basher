#!/bin/bash
set -e
# usage: $0 [optional egrep pattern]

function Go() {
    IFS=' '
    echo "-mindepth 1 -maxdepth 1 -executable" | \
        xargs  echo $PATH | \
        tr ':' ' ' | \
        xargs find | \
        {
            [[ "$*" == "" ]] && \
                cat \
            || \
                grep "$@"
        }
}

Go "$@"

