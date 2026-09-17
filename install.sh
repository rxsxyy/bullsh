#!/bin/sh

set -e

# load configuration
CONFIG="./install.conf"
if [ -f "$CONFIG" ]; then
  . "$CONFIG"
else
  echo "error: config file $CONFIG not found" >&2
  exit 1
fi

# ensure target directories exist
mkdir -p "$SHAREDIR"
mkdir -p "$BINDIR"

# copy source file while replacing __VERSION with the specified version string
echo "installing $TARGET_NAME version $VERSION to $SHAREDIR"
sed "s/__VERSION/$VERSION/g" "$SRC_FILE" > "$SHAREDIR/$TARGET_NAME.sh"
chmod 755 "$SHAREDIR/$TARGET_NAME.sh"

# create symlink without .sh extension in BINDIR
echo "creating symlink to $BINDIR/$TARGET_NAME"
ln -sf "$SHAREDIR/$TARGET_NAME.sh" "$BINDIR/$TARGET_NAME"

echo "done"