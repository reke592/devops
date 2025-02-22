#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Err: This script must be run as root. (use 'sudo')." >&2
  exit 1
fi

# link binaries to /usr/local/bin
BIN_PATH="$(dirname "$PWD")/bin"

for f in $BIN_PATH/*.sh; do 
  sudo chmod 770 "$f"
  LINK="/usr/local/bin/$(basename ${f//.sh/})"
  if [ -f "$LINK" ]; then
    sudo rm "$LINK"
  fi
  sudo ln -s "$f" "$LINK"
  echo "created symlink: $LINK -> $f"
done
