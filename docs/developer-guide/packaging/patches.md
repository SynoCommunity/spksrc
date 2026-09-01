# Patches

This page explains when and how to create source patches for spksrc packages.

## When to Use a Patch

A patch modifies the upstream source before it is configured and compiled.
Prefer Makefile-level solutions first — a patch should only be used when the
change cannot be expressed any other way:

- Use `CONFIGURE_ARGS`, `ADDITIONAL_CFLAGS`, or other Makefile variables when the
  project exposes the needed option
- Set environment variables with `ENV` when the build honors them
- Only fall back to a patch when the upstream code itself must change (a
  cross-compilation fix, a missing include, a hardcoded path, etc.)

Keeping the change in the Makefile documents *what* it does; a patch documents
*how* the source was edited. Prefer the former when possible.

## Location and Naming

Patches live in the `patches/` directory of the package that owns the source:

| Package type | Patch location |
|--------------|----------------|
| `cross/<pkg>/patches/` | For the library/tool's source |
| `native/<pkg>/patches/` | For host-build tools |
| `spk/<pkg>/patches/` | For files shipped with the SPK (scripts, config) |

Name patches sequentially with a numeric prefix and a short description:

```
patches/
├── 001-fix-cross-build.patch
└── 002-add-feature.patch
```

The numeric prefix fixes the application order. Without it, patches are applied
in alphabetical order, which is rarely what you want for related changes.

## How Patches Are Discovered

The framework auto-discovers patches from the package's `patches/` directory
(in `mk/spksrc.build/patch.mk`):

- `patches/*.patch` — applied for every architecture
- `patches/kernel-<KERNEL>/*.patch` — for a specific kernel
- `patches/DSM-<TCVERSION>/*.patch` and `patches/DSM-<major>/*.patch` — for a
  specific DSM/SRM version
- `patches/<arch>-<TCVERSION>/*.patch` and `patches/<arch>/*.patch` — for one
  architecture
- Group directories such as `patches/arm/`, `patches/x64/`,
  `patches/armv7-<TCVERSION>/`, … — for an architecture group

Use these subdirectories to keep generic fixes in `patches/` and
architecture- or version-specific fixes in their matching subdirectory.

You can also add explicit files from the Makefile:

```makefile
PATCHES += my-special.patch
```

## Patch Size

Keep each patch small and self-contained — one logical change per patch. A
large patch that mixes unrelated fixes is hard to review, hard to drop when
upstream fixes part of it, and prone to conflicts on version bumps. If you find
yourself writing a huge diff, split it into several numbered patches.

## Patch Level

Patches are applied with `patch -p$(PATCHES_LEVEL)`. The framework default is
`PATCHES_LEVEL = 0`, which matches diffs generated with `diff -Naur` against
the extracted source (as shown below). Do not override `PATCHES_LEVEL` unless
you have a specific reason (for example, importing a patch from upstream that
already uses `-p1` paths):

```makefile
PATCHES_LEVEL = 1
```

## Creating a Patch

The following walks through creating a patch for `cross/mypackage`:

### 1. Extract the source

Build the package once so the source is extracted (the build will likely fail —
that is fine):

```bash
cd cross/mypackage
mkdir -p patches
make clean
make arch-x64-7.2
```

The extracted source is in `$(WORK_DIR)/$(PKG_DIR)`, e.g.
`work-x64-7.2/mypackage-1.0.0/`.

### 2. Edit the source

Copy the file you need to change, edit the copy, then generate the diff:

```bash
cd work-x64-7.2/mypackage-1.0.0/
cp src/build.c src/build.c.org
# ... edit src/build.c with your changes ...
diff -Naur src/build.c.org src/build.c > ../../patches/001-fix-cross-build.patch
```

`diff -Naur` produces a unified diff with no directory prefixes — exactly what
`patch -p0` expects.

### 3. Clean and test

```bash
cd ../..
make clean
make arch-x64-7.2
```

Confirm the build now succeeds and the behavior is correct. Keep `patches/`
empty of anything that is not a patch (the `diff -Naur` target and `.org`
backup files must not be committed).

## Verifying Patches Apply Cleanly

Before submitting a PR, ensure every patch applies without fuzz or offset
warnings (the CI treats those as failures):

```bash
make clean
make arch-x64-7.2
```

If a patch no longer applies after a source version bump, update it against the
new extraction following the steps above.