# native/llvm-14.0-build — maintainer entry point

**Do not remove this package because nothing depends on it. Nothing is supposed
to depend on it.**

This is a maintainer-run recipe, not a build dependency. It regenerates the
prebuilt `native-llvm-14.0_*.txz` tarball published under
[releases/tag/native%2Fllvm](https://github.com/SynoCommunity/spksrc/releases/tag/native%2Fllvm),
which `native/llvm-14.0` then downloads. Packages depend on `native/llvm-14.0`
(the tarball), never on this recipe — that indirection is what keeps the
intel-graphics-compiler / synocli-videodriver chain from rebuilding LLVM from
source on every CI run.

Because of that indirection, this package is deliberately unreachable from any
`spk/` entry point. A dependency-graph sweep will therefore report it, and the
whole recipe chain hanging off it, as dead code. It is not:

    native/llvm-14.0-build          <- this recipe (maintainer entry point)
     +- native/llvm-140
     +- native/Khronos-SPIRV-LLVM-Translator-140
     +- native/intel-vc-intrinsics
     +- native/intel-opencl-clang-140
         `- native/Khronos-{OpenCL-Headers,SPIRV-Headers,SPIRV-Tools}

Treating this package as a graph root makes every one of the above reachable
again, which is the check to run before concluding any of them is orphaned.

To rebuild and publish the tarball, see the REMARKS block at the top of the
`Makefile` and run `make build-archive`.
