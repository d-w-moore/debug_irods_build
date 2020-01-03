#!/bin/bash
docker build --build-arg={login=`whoami`,uid=`id -u`,gid=`id -g`} -t rrdock:new . $*
