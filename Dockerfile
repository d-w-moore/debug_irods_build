FROM ubuntu:16.04

ARG login
ENV LOGIN="$login"
ARG uid
ENV UID="$uid"
ARG gid
ENV GID="$gid"

# -- rr
RUN apt-get update && \
    apt-get install -y git vim gcc

RUN apt-get install -y ccache cmake make g++-multilib gdb pkg-config \
      coreutils python3-pexpect manpages-dev git ninja-build capnproto \
      libcapnp-dev

RUN git clone http://github.com/mozilla/rr && \
    mkdir obj && cd obj && \
    cmake ../rr && \
    make -j8 && \
    make install
# --
#RUN apt-get update
RUN apt-get install -y wget vim git sudo exuberant-ctags cscope tmux
RUN groupadd -g $GID $LOGIN
RUN useradd -s /bin/bash -md /home/$LOGIN -g $GID -u $UID $LOGIN
RUN echo "$LOGIN ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

COPY db_commands.txt /
WORKDIR /home/$login
COPY build_history .
RUN  chown $login:$login build_history
USER $login
#RUN git clone http://github.com/d-w-moore/ubuntu_irods_installer
#CMD ["/bin/bash"]
