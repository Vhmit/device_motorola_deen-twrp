#!/bin/bash

add_lunch_combo omni_deen-eng

# Apply deen-specific build fixes.
if [ -n "$ANDROID_BUILD_TOP" ]; then
    PATCH_SCRIPT="$ANDROID_BUILD_TOP/device/motorola/deen/patches/apply.sh"

    if [ -x "$PATCH_SCRIPT" ]; then
        "$PATCH_SCRIPT"
    fi
fi
