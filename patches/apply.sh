#!/bin/bash

set -e

TOP="${ANDROID_BUILD_TOP:-$(pwd)}"
MAKEFILE="${TOP}/build/core/Makefile"

MARKER="# deen: generate recovery installer cpio"

if [ ! -f "$MAKEFILE" ]; then
    echo "deen: build/core/Makefile not found"
    exit 1
fi

if grep -qF "$MARKER" "$MAKEFILE"; then
    echo "deen: recovery installer patch already applied"
    exit 0
fi

python3 <<'EOF'
import os

top = os.environ.get("ANDROID_BUILD_TOP", os.getcwd())
path = os.path.join(top, "build/core/Makefile")

with open(path, "r") as f:
    data = f.read()

needle = """\
\t\t$(call build-recoveryramdisk)
\t\t$(hide) $(MKBOOTFS) -d $(TARGET_OUT) $(TARGET_RECOVERY_ROOT_OUT) | $(RECOVERY_RAMDISK_COMPRESSOR) > $(recovery_ramdisk)
"""

replacement = """\
\t\t$(call build-recoveryramdisk)
\t\t# deen: generate recovery installer cpio
\t\t$(hide) $(MKBOOTFS) $(TARGET_RECOVERY_ROOT_OUT) > $(recovery_uncompressed_ramdisk)
\t\t$(hide) $(MKBOOTFS) -d $(TARGET_OUT) $(TARGET_RECOVERY_ROOT_OUT) | $(RECOVERY_RAMDISK_COMPRESSOR) > $(recovery_ramdisk)
"""

if needle not in data:
    raise SystemExit(
        "deen: expected TWRP 9 recovery ramdisk block was not found"
    )

data = data.replace(needle, replacement, 1)

with open(path, "w") as f:
    f.write(data)

print("deen: recovery installer cpio patch applied")
EOF
