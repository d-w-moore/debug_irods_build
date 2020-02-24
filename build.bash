#!/bin/bash

unset FORCE_TOOL_RECOMPILE
TAGINFO=("-t" "debugger:latest")

while getopts  ":t:fF" opt; do
    case $opt in
      f) FORCE_TOOL_RECOMPILE="" ;;
      F) FORCE_TOOL_RECOMPILE="--no-cache" ;;
      t) TAGINFO=("-t" "$OPTARG") ;;
      \?) break ;;
    esac
done

shift $((OPTIND-1))

if [ "${FORCE_TOOL_RECOMPILE+.}" = "." -o `docker image ls -q debug_tools | wc -l` -lt 1 ]; then
  $(dirname "$0")/bldtools.bash # - build rr,gdb,valgrind separately
fi

docker build --build-arg={login=`whoami`,uid=`id -u`,gid=`id -g`} "${TAGINFO[@]}" . "$@"

