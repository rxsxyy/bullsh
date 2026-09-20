#!/bin/sh

# source the build instruction file if it exists
if [ -f "bull.bs" ]; then
  . ./bull.bs
fi

MODE="${1:-build}"

case "$MODE" in

  # creates a bull.bs file in the current directory with default values
  init)
    if [ ! -f "bull.bs" ]; then
      echo "PROJECT=$(basename $PWD)" >> bull.bs
      echo "OUT=./$(basename $PWD)" >> bull.bs
    else
      echo "project already initialized"
      exit 1
    fi
    ;;

  # runs the command defined in CMD, requires SRC to be set
  build)
    if [ ! -f "bull.bs" ]; then
      echo "bull.bs not found"
      exit 1
    elif [ -z "$SRC" ]; then
      echo "SRC is not set. use '$0 add <file>' or edit bull.bs"
      exit 1
    fi
    TARGET="${2:-}"
    case "$TARGET" in
      "")
        TARGET_CMD="$CMD"
        VARNAME="CMD"
        ;;
      *[!a-zA-Z0-9_]*)
        echo "invalid target name '$TARGET'"
        exit 1
        ;;
      *)
        VARNAME="CMD_$TARGET"
        eval "TARGET_CMD=\"\$$VARNAME\""
        ;;
    esac
    if [ -z "$TARGET_CMD" ]; then
      echo "$VARNAME is not set. use '$0 set $VARNAME '<command>'' or edit bull.bs"
      exit 1
    fi
    echo "building $PROJECT${TARGET:+ ($TARGET)}..."
    sh -c "$TARGET_CMD"
    ;;

  # appends a file to the SRC variable in bull.bs
  add)
    if [ ! -f "bull.bs" ]; then
      echo "bull.bs not found."
      exit 1
    elif [ -z "$2" ]; then
      echo "usage: $0 add <file>"
      exit 1
    elif [ ! -f "$2" ]; then
      echo "file '$2' not found"
      exit 1
    fi
    case " $SRC " in
      *" $2 "*) echo "'$2' already in SRC" ; exit 1 ;;
    esac
    if grep -q "^SRC=" bull.bs; then
      if [ -z "$SRC" ]; then
        sed "s|^SRC=.*|SRC=\"$2\"|" bull.bs > bull.bs.tmp && mv bull.bs.tmp bull.bs
      else
        sed "s|^SRC=.*|SRC=\"$SRC $2\"|" bull.bs > bull.bs.tmp && mv bull.bs.tmp bull.bs
      fi
    else
      echo "SRC=\"$2\"" >> bull.bs
    fi
    ;;

  # sets or updates a key-value pair in bull.bs
  set)
    if [ ! -f "bull.bs" ]; then
      echo "'bull.bs' not found."
      exit 1
    elif [ -z "$2" ] || [ -z "$3" ]; then
      echo "usage: $0 set <key> <value>"
      exit 1
    fi
    KEY="$2"; shift 2; VALUE="$*"
    if grep -q "^$KEY=" bull.bs; then
      sed "s|^$KEY=.*|$KEY=\"$VALUE\"|" bull.bs > bull.bs.tmp && mv bull.bs.tmp bull.bs
    else
      echo "$KEY=\"$VALUE\"" >> bull.bs
    fi
    ;;

  # prints usage information
  help)
    echo "usage: $0 [init|build [target]|add|set|help|version]"
    ;;
  
  # prints program version
  version)
    echo "bull v__VERSION"
    ;;

  *)
    echo "usage: $0 [init|build [target]|add|set|help|version]" >&2
    exit 1
    ;;

esac
