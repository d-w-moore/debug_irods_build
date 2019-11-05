#!/bin/bash
SCRIPTDIR=$(readlink -e "`dirname $0`")
CONTAINER_DIR=/opt/irods-externals
REMOVE_OPTION=""
GITHUB_PATH="$HOME/github"
QUIT=""
VERBOSE=""

#
# $0 [-rm] irods_builder_image volume_for_externals
#
usage() { echo "
 $0 [-rm] [-gh github_dir] -q -v -h\
 irods_builder_image volume_for_externals
"; } >&2

while [[ $1 = -* ]]; do
  case ${1#-} in
    -h|h|-help|help) usage; exit 0 ;;
    -v|v|-verb*|verb*) VERBOSE="1";shift;;
    -q|q|-quit|quit) QUIT="1";shift;;
    -gh|gh|-github|github) 
            GITHUB_PATH="$2"; shift 2;;
    -rm|rm) REMOVE_OPTION="--rm"; shift;;
  esac
done 

[ -n "$VERBOSE" ] && {
    echo >&2 "REMOVE_OPTION=""$REMOVE_OPTION"
    echo >&2 "GITHUB_PATH=""$GITHUB_PATH"
}

[ -n "$QUIT" ] && {
    exit 1;
}

if [ $# -gt 1 ];then
    src="$2"
    MOUNT_W_OPTION="--mount src=$2,dst=$CONTAINER_DIR"
else
    MOUNT_W_OPTION=""
fi

# "--privileged" may be needed in some OSes for 
#   'systemctl stop rsyslog' ('service rsyslog stop')

docker run -it $REMOVE_OPTION \
-v  "$GITHUB_PATH:/home/$USER/github"  \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  --privileged \
  $MOUNT_W_OPTION \
  "$1" bash
