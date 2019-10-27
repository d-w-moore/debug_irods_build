FROM ubuntu:16.04

ARG login
ENV LOGIN="$login"
ARG uid
ENV UID="$uid"
ARG gid
ENV GID="$gid"

RUN apt-get update
RUN apt-get install -y wget vim git sudo ctags
RUN groupadd -g $GID $LOGIN
RUN useradd -s /bin/bash -md /home/$LOGIN -g $GID -u $UID $LOGIN

COPY db_commands.txt /
WORKDIR /home/$login
COPY build_history .
RUN  chown $login:$login build_history
USER $login
