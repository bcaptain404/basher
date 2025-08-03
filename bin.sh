#!/bin/bash
set -e
# usage: $0 [optional egrep pattern]

function Go() {
    IFS=' '
    local DEPTH=(-mindepth 1 -maxdepth 1)
    local TYPE=(-executable)
    local PATHS=()
    local TERM
    local DEBUG=0
    local NOPATH=0
    local WHICH=0
    
    local A
    while (( $# > 0 )) ; do
        if [[ "$1" == "-l" ]] ; then
            TYPE+=(-or -xtype executable)
        elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]] ; then
            echo 'searches for executable binaries insite specified paths'
            echo '(or $PATH by default). Prints a "*" for `which` of each,'
            echo 'and an "!" if which'" doesn't find it"
            echo ''
            echo "Usage: $0 [regex] [search_paths or options]"
            echo "  -S            also shows symlinks to executables"
            echo '  -W            print "*" for `which` status, "!" for not.'
            echo '  -X            search for non-executable files instead'
            echo '  -p [path]     include a path to search'
            echo '  -pp           dont search $PATH'
            echo '  -             all other options are passed to `egrep`'
            echo "  -h, --help    show help"
            echo "  --debug       debug"
            echo "Examples:"
            echo "  $0 my_bin"
            echo "  $0 my_Bin -i #case insensitive search"
            echo '  $0 my_bin -p search_dir1 -p search_dir2'
            #echo '  $0 my_bin -p search_dir1 -p search_dir2 -p $PATH' #todo
            echo "  $0 my_bin -p"
            exit 0
        elif [[ "$1" == "--debug" ]] ; then
            DEBUG=1
        elif [[ "$1" == "-X" ]] ; then
            local TYPE=(-not -executable)
        elif [[ "$1" == "-W" ]] ; then
            WHICH="1"
        elif [[ "$1" == "-pp" ]] ; then
            NOPATH="1"
        elif [[ "$1" == "-p" ]] ; then
            shift
            PATHS+=("$1")
        else
            TERM+=("$1")
        fi
        shift
    done

    if [[ "$NOPATH" == "0" ]] ; then
        local P
        while read P ; do
            PATHS+=("$P")
        done <<< "$(echo "$PATH" | tr ':' $'\n')"
    fi

    if (( "${#PATHS[@]}" == 0 )) ; then
        echo "No paths selected." >&2
        exit 1
    fi

    (( ${#TERM[@]} == 0 )) && TERM+=("")

    [[ "$DEBUG" == "1" ]] && {
        local P
        for P in ${PATHS[@]} ; do
            echo "## DEBUG:   $P" >&2
        done

        echo "## DEBUG: TYPE: ${TYPE[@]}" >&2
        echo "## DEBUG: TERM: ${TERM[@]}" >&2
        echo "## DEBUG: PATHS:"
        echo "## DEBUG:" find "${PATHS[@]}" >&2
        echo "## DEBUG:" egrep "${TERM[@]}" >&2
    }

    local F
    while read F ; do
        if [[ "$WHICH" == "1" ]] ; then    
            local W="$(which "$(basename "$F")")"
            if [[ "$W" == "$F" ]] ; then
                echo "* $F"
                continue
            else
                printf '! '
            fi
        fi
        echo "$F"
    done <<<"$( find "${PATHS[@]}" "${DEPTH[@]}" "${TYPE[@]}" | egrep "${TERM[@]}")"
}

Go "$@"

