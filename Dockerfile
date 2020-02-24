FROM ubuntu:16.04

ARG login
ENV LOGIN="$login"
ARG uid
ENV UID="$uid"
ARG gid
ENV GID="$gid"

RUN apt-get update && \
    apt-get install -y git vim make info libncurses5 g++ make \
                     g++-multilib gdb coreutils python3-pexpect capnproto # for rr 
RUN apt-get install -y wget vim git sudo exuberant-ctags cscope tmux
RUN groupadd -g $GID $LOGIN
RUN useradd -s /bin/bash -md /home/$LOGIN -g $GID -u $UID $LOGIN
RUN echo "$LOGIN ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

COPY db_commands.txt /
COPY --from=debug_tools /usr/local/gdb /usr/local/gdb
COPY --from=debug_tools /usr/local/rr  /usr/local/rr
COPY --from=debug_tools /usr/local/valgrind /usr/local/valgrind

WORKDIR /home/$login
RUN  mkdir /usr/local/misc
COPY koutheir.sh /usr/local/misc/.

USER $login

RUN git clone http://github.com/d-w-moore/ubuntu_irods_installer

CMD ["/bin/bash"]
