#!/bin/sh

set -e

CONFIG="./install.conf"
if [ -f "$CONFIG" ]; then
  . "$CONFIG"
else
  echo "error: config file $CONFIG not found" >&2
  exit 1
fi

echo "removing $TARGET_NAME version $VERSION from $BINDIR"
rm -f "$BINDIR/$TARGET_NAME"

echo "removing $TARGET_NAME.sh from $SHAREDIR"
rm -rf "$SHAREDIR/$TARGET_NAME.sh"

echo "done"