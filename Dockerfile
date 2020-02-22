FROM ubuntu:16.04

ARG login
ENV LOGIN="$login"
ARG uid
ENV UID="$uid"
ARG gid
ENV GID="$gid"

ARG commit="47f13a8"
#ARG commit=""

# -- rr
RUN apt-get update && \
    apt-get install -y git vim gcc

RUN apt-get install -y ccache cmake make g++-multilib gdb pkg-config \
      coreutils python3-pexpect manpages-dev git ninja-build capnproto \
      libcapnp-dev

RUN git clone http://github.com/mozilla/rr && \
    cd rr && \
    { [ -z "${commit}" ] || git checkout "${commit}"; } && \
    mkdir ../obj && cd ../obj && \
    cmake ../rr && \
    make -j8 && \
    make install

RUN apt-get install -y wget vim git sudo exuberant-ctags cscope tmux
RUN groupadd -g $GID $LOGIN
RUN useradd -s /bin/bash -md /home/$LOGIN -g $GID -u $UID $LOGIN
RUN echo "$LOGIN ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

RUN apt install -y bzip2
WORKDIR /tmp
RUN wget  https://sourceware.org/pub/valgrind/valgrind-3.15.0.tar.bz2
RUN wget  http://ftp.gnu.org/gnu/gdb/gdb-8.3.1.tar.gz
# texinfo     - so gdb can install info files (fails make install otherwise)
# libncurses5 - for gdb TUI mode
RUN apt install -y texinfo libncurses5 libncurses5-dev
RUN tar xzf gdb*gz && cd gdb*/ \
    && ./configure --prefix=/usr/local/gdb --with-curses --enable-tui \
    && make -j3
RUN mkdir /usr/local/gdb && cd gdb*/ && make install
RUN tar xjf valgrind*bz2 && cd valgrind*/ && \
    ./configure --prefix=/usr/local/valgrind && \
    mkdir /usr/local/valgrind && \
    make -j7 install

COPY db_commands.txt /
WORKDIR /home/$login
#COPY build_history .
#RUN  chown $login:$login build_history
USER $login
RUN git clone http://github.com/d-w-moore/ubuntu_irods_installer
CMD ["/bin/bash"]
