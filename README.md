stack-spack
===========

This project contains bash scripts to setup a Spack-based software stack and find a suitable system compiler.

Useful information before beginning
-----------------------------------

Spack works only on Linux and MacOS platforms. Windows is [not supported](https://github.com/spack/spack/issues/1515).

Before installing Spack, make sure your system supports [Environment Modules](http://modules.sourceforge.net/) package. It can be easily [installed](https://modules.readthedocs.io/en/stable/INSTALL.html).

Ensure your system has the minimum Spack [prerequisites](https://spack.readthedocs.io/en/latest/getting_started.html#prerequisites). 

Installation
------------

```
$ ./install-spack.sh <stack_root>
```

where `<stack_root>` is root directory of the desired software stack. For example:

```
$ ./install-spack.sh ../stack-2019.03
```

Find a suitable system compiler that can install Spack packages 
---------------------------------------------------------------

- In our limited experience, many system compilers fail for various reasons to install complex software stacks. 

- On Linux systems, the approach that has been most consistent for us has been to build `gcc-7.3.0` and `binutils` using a suitable system compiler. Then, we use the installed `Spack gcc-7.3.0` to build the remaining software stack.

- One can use a `system gcc-7.3.0` to build the `Spack gcc-7.3.0`. In fact, we had to do this very thing in the past in order to reliably build some ornery software stacks on our systems. 

- On MacOS systems, one can build `gcc-7.3.0` using a `clang` compiler, but `gcc` on a Mac does not play well with `cmake` and other packages. So, on MacOS, we recommend to stick with only `clang` compilers.

- Below is a typical work flow that selects `gcc-7.3.0` as its final system compiler.
```
$ cd <stack_root>

$ source 1-setup-spack.sh
$ echo $SPACK_ROOT   # the output should be same as your current directory

$ ./scripts/compiler.sh add
$ ./scripts/compiler.sh avail

$ ./scripts/compiler.sh try gcc@4.4.7

$ module load gcc/4.9.3
$ ./scripts/compiler.sh add gcc@4.9.3
$ ./scripts/compiler.sh try gcc@4.9.3

$ module load gcc/7.3.0
$ ./scripts/compiler.sh add gcc@7.3.0.
$ ./scripts/compiler.sh try gcc@7.3.0.
$ ./scripts/compiler.sh use gcc@7.3.0.
```

**Be advised: 
A system compiler may succeed in installing the small package (libelf) related to try-compiler.sh, but may fail for various other reasons during the build of the more complex stack packages. If this happens, setup another system compiler, and try again.**

version: 2019.02.19
