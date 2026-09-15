#!/bin/sh

set -e

CONFIG="./install.conf"
[ -f "$CONFIG" ] && . "$CONFIG"

echo "removing $DESTDIR$BINDIR/$TARGET_NAME"
rm -f "$DESTDIR$BINDIR/$TARGET_NAME"

echo "removing $DESTDIR$SHAREDIR"
rm -rf "$DESTDIR$SHAREDIR"

echo "done"