# Debug iRODS Build

# build for your user

  - see instructions printed by `./build.bash -h`

Internally, running build.bash without options will
  - build the debugging tools `gdb`, `rr`, and `valgrind` into a first image>
    The process is to check (optionally force) that the `build_debuggers` image exists
    and then do something like:
  - build a second image called `use_debuggers` by default, with the executables for the
    above-described debuggers copied in from the first
    The image is built something like this, to preserve the host user's identity

  ```
  docker build -t debug_my_irods --build-arg={login=`whoami`,uid=`id -u`,gid=`id -g`} .
  ```

  - when running the `use_debuggers` image under control of `rr_docker.sh`, the
  `~/github` directory (with iRODS source , etc) is mapped into the container

  - Note that the  `rr_docker.sh` script uses the docker-run security/privilege options
    that enable debuggers such as gdb and rr to function properly. Be sure to deploy 
    these options yourself if running docker manually.
