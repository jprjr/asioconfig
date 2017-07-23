# asioconfig

This is just a dumb lil' program for pulling up ASIO device's control panels.

## Downloading

Click the [releases tab](https://github.com/jprjr/asioconfig/releases) for downloads.

## Building

First, you'll need to download the ASIO SDK and extracted it to the root of this
repo.

Run `git submodule update --init` to pull in the `iup` folder.

Make sure you have a mingw cross-compiler installed, then run:

```
make TARGET=i686-w64-mingw32
```

Replace TARGET with whatever's appropriate.

## LICENSE

This program is released under an MIT license, see `LICENSE`
