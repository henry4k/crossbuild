crossbuild with meson and conan
===============================

This extends [multiarch/crossbuild][1] with several new build tools (conan,
meson, ninja), toolchain configurations several build tools and a
crosscompiling automation.

On Docker hub: https://hub.docker.com/r/henry4k/crossbuild


Usage
-----

Its generally used like [multiarch/crossbuild][1] but with the following differences:

- `PATH` and `LD_LIBRARY_PATH` are not automatically adapted by the `CROSS_TRIPLE` environment variable.
  This is necessary because it confuses Meson.  (Though one could argue about the latter one.)
- Container runs `autocrossbuild` instead of `bash` by default. (See below)


The `autocrossbuild` script can be used to automate the configure, compile,
install steps.  It does so by looking in the source directory for known build
systems.  (Currently it supports Conan, Meson and CMake.) The scripts behaviour
depends on several environment variables. (See below)


Toolchains
----------

There are ready-made toolchain files for various build systems.
All toolchain files use the host triple as filename.


### Conan

Conan profiles are located in `/root/.conan/profiles`.

As long as conan is run as root they can be used by passing `--profile <triple>` to conan.


### Meson

Meson cross files are located in `/usr/share/meson/cross`.

Just pass `--cross-file <triple>` to meson to use one.


### CMake

CMake toolchains are located in `/root/.cmake/toolchains`.

Pass `-DCMAKE_TOOLCHAIN_FILE=/root/.cmake/toolchains/<triple>` to use one.


Environment variables
---------------------

### `CROSS_TRIPLE`

The host triple - see [multiarch/crossbuild][1]
for a list of possible values.

This one is *required* when using `autocrossbuild`.


### `ABC_SOURCE_DIR`

Directory that `autocrossbuild` expects to contain your projects source code.

Default: `/source`


### `ACB_INSTALL_DIR`

Directory that `autocrossbuild` uses for installation.

Default: `/install`


### `ACB_BUILD_STEPS`

A comma separated list of build steps.

The build driver (i.e. Ninja) is called with these in order.

Default:

1. default target (as empty string: `''`)
2. `test`
3. `install`


### `ACB_CONAN_INSTALL_ARGS`

Extra arguments that are passed to `conan install`.


### `ACB_MESON_ARGS`

Extra arguments that are passed to Meson.


### `ACB_CMAKE_ARGS`

Extra arguments that are passed to CMake.


### `ACB_NINJA_ARGS`

Extra arguments that are passed to Ninja - which is always used to drive the
actual building. (This means Meson *and* CMake.)

Useful arguments could be `-v` for more verbose output and `-l N`/`-j N` for
load control.


[1](https://github.com/multiarch/crossbuild)
