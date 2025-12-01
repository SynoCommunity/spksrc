#!/bin/bash
set -e

WORK_FOLDER=helix
DEST=${WORK_FOLDER}/.cargo
DEST_PATCHES=${DEST}/patches/cc
mkdir -p ${DEST_PATCHES}

# 1) download crate
wget https://crates.io/api/v1/crates/cc/1.2.29/download -O ${WORK_FOLDER}/cc-1.2.29.crate

# 2) untar
tar -xf ${WORK_FOLDER}/cc-1.2.29.crate -C ${DEST_PATCHES}

# 3) apply patch (avoid -m64 parameter for cross compilation)
cat <<'PATCH' | patch -d ${DEST_PATCHES}/cc-1.2.29 -p1 -b
--- a/src/lib.rs	2006-07-24 01:21:28.000000000 +0000
+++ b/src/lib.rs	2025-11-30 13:30:08.964925484 +0000
@@ -2180,8 +2180,6 @@
                 } else {
                     cmd.args.push("-m64".into());
                 }
-            } else if target.arch == "x86_64" || target.arch == "powerpc64" {
-                cmd.args.push("-m64".into());
             }
         }

PATCH

# 4) create Tarball
tar -czf cargo-cc-patched-1.2.29.tar.gz -C ${WORK_FOLDER} .cargo
echo "Created cargo-cc-patched-1.2.29.tar.gz"

# 5) Cleanup
rm -rf ${WORK_FOLDER}
