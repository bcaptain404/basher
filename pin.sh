#!/bin/bash

PINS_FILE="$HOME/.bash_pins"
HIST_FILE="$HOME/.bash_history"

# Ensure pins file exists
touch "$PINS_FILE"

print_help() {
  cat <<EOF
Usage: pin [options] [command]

Examples:
  pin "echo hello"            # Pins a raw command
  pin -- ls -l                # Pins a raw command (alternative form)
  pin -n 3                    # Pins line 3 of .bash_history
  pin -n 3 -m "List files"    # Pins line 3 with comment
  pin -n 70-80                # Pins line 70 through 80 from history
  pin -s "foo"                # egrep -ni pins for 'foo'
  pin -l                      # List all pinned commands
  pin -u 15                   # Unpin line 15
  pin -u 15-17                # Unpin lines 15 through 17
EOF
}

# Add a pin
add_pin() {
  local content="$1"
  echo "$content" >> "$PINS_FILE"
  echo "Pinned: $content"
}

# Remove lines from .bash_pins
remove_pins() {
  local range="$1"
  local tmpfile=$(mktemp)

  awk -v range="$range" '
    BEGIN {
      split(range, parts, "-");
      start = parts[1];
      end = (parts[2] ? parts[2] : parts[1]);
    }
    NR < start || NR > end {
      print
    }
  ' "$PINS_FILE" > "$tmpfile"

  mv "$tmpfile" "$PINS_FILE"
  echo "Removed lines $range"
}

# Main logic
if [[ $# -eq 0 ]]; then
  print_help
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -l)
      cat -n "$PINS_FILE"
      exit 0
      ;;
    -s)
      shift
      egrep -ni --color=always "$1" "$PINS_FILE"
      exit 0
      ;;
    -u)
      shift
      remove_pins "$1"
      exit 0
      ;;
    -n)
      shift
      RANGE="$1"
      shift
      COMMENT=""
      if [[ "$1" == "-m" ]]; then
        shift
        COMMENT="# $1"
        shift
      fi
      START=$(echo "$RANGE" | cut -d- -f1)
      END=$(echo "$RANGE" | cut -d- -f2)
      [[ -z "$END" ]] && END=$START

      for i in $(seq "$START" "$END"); do
        CMD=$(sed -n "${i}p" "$HIST_FILE")
        [[ -n "$CMD" ]] && add_pin "$CMD $COMMENT"
      done
      exit 0
      ;;
    --)
      shift
      CMD="$*"
      add_pin "$CMD"
      exit 0
      ;;
    -*|--*)
      echo "Unknown flag: $1"
      print_help
      exit 1
      ;;
    *)
      CMD="$*"
      add_pin "$CMD"
      exit 0
      ;;
  esac
  shift
done
