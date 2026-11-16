#!/bin/bash
#
# Auto-increment SPK_REV in Makefile
# Usage: ./scripts/bump-revision.sh
#

MAKEFILE="$(dirname "$0")/../Makefile"

if [ ! -f "$MAKEFILE" ]; then
    echo "ERROR: Makefile not found at $MAKEFILE"
    exit 1
fi

# Get current revision
CURRENT_REV=$(grep -E "^SPK_REV\s*=" "$MAKEFILE" | sed 's/SPK_REV\s*=\s*//')

if [ -z "$CURRENT_REV" ]; then
    echo "ERROR: Could not find SPK_REV in Makefile"
    exit 1
fi

# Increment revision
NEW_REV=$((CURRENT_REV + 1))

# Update Makefile
sed -i "s/^SPK_REV\s*=\s*[0-9]*/SPK_REV = ${NEW_REV}/" "$MAKEFILE"

echo "Bumped SPK_REV: $CURRENT_REV -> $NEW_REV"
