#!/bin/bash

unset FORCE_TOOL_RECOMPILE
TAGINFO=("-t" "use_debuggers:latest")
usage() { cat<<-EOF

	Creates: - a first docker image called "build_debuggers" in which
		   gdb,rr, and valgrind are compiled from source
		 - a second docker image called "use_debuggers" which
		   imports the debugger executables from "build_debuggers"
		   (This second image is meant to be used with rr_docker.sh,
		   however you can optionally just steal the docker run
		   options for debugging from there and write your own)

	Building docker images:

	`basename "$0"` [opts]

	-[f|F] force build_debuggers to be rebuilt if not preexisting
	       (F forces with docker's --no-cache option)

	-t     rename the 2nd container (into which gdb,rr,valgrind are
	       imported). The default name is "use_debuggers"

	Sample build/usage steps:

	\$ ./build.bash -F               # - to build both images

	\$ ./rr_docker.sh use_debuggers  # - to run image with debugger
	                                    executables available and
	                                    ~/github mapped into container

	Note - under Linux, /proc/sys/kernel/perf_event_paranoid may
	       need to be set <= 1 on the host.  See: man sysctl
	EOF
  if [ $# -ge 1 ]; then exit $1; fi
}
while getopts  ":t:hfF" opt; do
    case $opt in
      h) usage 0;;
      f) FORCE_TOOL_RECOMPILE="" ;;
      F) FORCE_TOOL_RECOMPILE="--no-cache" ;;
      t) TAGINFO=("-t" "$OPTARG") ;;
      \?) break ;;
    esac
done

shift $((OPTIND-1))

if [ "${FORCE_TOOL_RECOMPILE+.}" = "." \
  -o `docker image ls -q build_debuggers | wc -l` -lt 1 ]
then
  $(dirname "$0")/build_debuggers.bash $FORCE_TOOL_RECOMPILE # - build rr,gdb,valgrind separately
fi
BLDDIR=$(dirname "$0")
cd  "$BLDDIR"
docker build --build-arg={login=`whoami`,uid=`id -u`,gid=`id -g`} "${TAGINFO[@]}" "$@" .

