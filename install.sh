#!/bin/sh

set -e

# Load configuration
CONFIG="./install.conf"
if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
    echo "error: config file $CONFIG not found" >&2
    exit 1
fi

# Ensure target directory exists
mkdir -p "$DESTDIR$SHAREDIR"
mkdir -p "$DESTDIR$BINDIR"

# Copy source script to target share directory
echo "installing source script to $DESTDIR$SHAREDIR"
cp -f "$SRC_FILE" "$DESTDIR$SHAREDIR/$TARGET_NAME.sh"
chmod 755 "$DESTDIR$SHAREDIR/$TARGET_NAME.sh"

# Create symlink without .sh extension in BINDIR
echo "creating symlink $DESTDIR$BINDIR/$TARGET_NAME"
ln -sf "$SHAREDIR/$TARGET_NAME.sh" "$DESTDIR$BINDIR/$TARGET_NAME"

echo "done"
