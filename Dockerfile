FROM ubuntu:16.04

ARG login
ENV LOGIN="$login"
ARG uid
ENV UID="$uid"
ARG gid
ENV GID="$gid"

ARG parallelism=3

# "" to default to tip
ARG rr_commit="47f13a8"  

# -- rr
RUN apt-get update && \
    apt-get install -y git vim gcc

RUN apt-get install -y ccache cmake make g++-multilib gdb pkg-config \
      coreutils python3-pexpect manpages-dev git ninja-build capnproto \
      libcapnp-dev

RUN git clone http://github.com/mozilla/rr && \
    cd rr && \
    { [ -z "${rr_commit}" ] || git checkout "${rr_commit}"; } && \
    mkdir ../obj && cd ../obj && \
    cmake ../rr && \
    make -j${parallelism} && \
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
    && make -j${parallelism}
RUN mkdir /usr/local/gdb && cd gdb*/ && make install
RUN tar xjf valgrind*bz2 && cd valgrind*/ && \
    ./configure --prefix=/usr/local/valgrind && \
    mkdir /usr/local/valgrind && \
    make -j${parallelism} install
RUN rm -fr /rr /obj /tmp/valgrind*/ /tmp/gdb*/
COPY db_commands.txt /
WORKDIR /home/$login
#COPY build_history .
#RUN  chown $login:$login build_history
USER $login
RUN git clone http://github.com/d-w-moore/ubuntu_irods_installer
CMD ["/bin/bash"]
