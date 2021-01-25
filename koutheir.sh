
apt-get update
apt-get install make

cd ~ ; git clone http://github.com/llvm/llvm-project

cd llvm-project && \
    mkdir build && \
    cd build && \
    /opt/irods-externals/cmake3.11.4-0/bin/cmake \
        -G "Unix Makefiles"  -DLLVM_ENABLE_PROJECTS="libcxx;libcxxabi" ../llvm && \
    make -j3 cxx cxxabi

/opt/irods-externals/clang6.0-0/bin/clang++ -Wl,-rpath=$HOME/llvm-project/build/lib demo.cpp -stdlib=libc++ -g -O0 -std=c++17

# -- Install & configure pretty-printers

apt install -y python  # apt remove -y python3

git clone https://github.com/koutheir/libcxx-pretty-printers
cd libcxx-pretty-printers && git checkout "5ffbf2487bf8da7f08bc1c8650a4396d2ff15403"

PP_SRC_DIR=~/libcxx-pretty-printers/src
ln -s $PP_SRC_DIR/gdbinit ~/.gdbinit && sed -i.orig -e "s@<path.*>@$PP_SRC_DIR@" $PP_SRC_DIR/gdbinit
