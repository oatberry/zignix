# zignix
A toy kernel written in the fascinating new [Zig](https://ziglang.org) language

## building & running
builds only with Zig master branch as of 2018/11/13

```shell
$ zig build-exe zignix.zig --target-os freestanding --target-arch i386 --linker-script linker.ld
$ qemu-system-i386 -kernel zignix
```
