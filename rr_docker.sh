#!/bin/bash
SCRIPTDIR=$(readlink -e "`dirname $0`")
CONTAINER_DIR=/opt/irods-externals
REMOVE_OPTION=""

while [[ $1 = -* ]]; do
  case ${1#-} in
    -rm|rm) REMOVE_OPTION="--rm"; shift;;
  esac
done 

if [ $# -gt 1 ];then
    src="$2"
    MOUNT_W_OPTION="--mount src=$2,dst=$CONTAINER_DIR"
else
    MOUNT_W_OPTION=""
fi

#-v "$SCRIPTDIR"/github:/home/$USER/github  \
docker run -it $REMOVE_OPTION \
-v  /home/$USER/github:/home/$USER/github  \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  $MOUNT_W_OPTION \
  "$1" bash
