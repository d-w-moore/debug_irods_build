#!/bin/bash

TAGINFO=("-t" "debugger:latest")

while getopts  ":t:" opt; do
    case $opt in
      t) TAGINFO=("-t" "$OPTARG") ;;
      \?) break ;;
    esac
done

shift $((OPTIND-1))

docker build --build-arg={login=`whoami`,uid=`id -u`,gid=`id -g`} "${TAGINFO[@]}" "$@"

