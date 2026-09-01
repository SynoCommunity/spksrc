#!/usr/bin/env python3
"""Inject --cross-file arguments into the [tool.meson-python.args] setup table.

meson-python reads setup args from this table for every meson invocation,
including the metadata-generation setup that does not receive config-settings,
so cross files placed here are applied consistently across the build.

Handles three cases: an existing setup key, an existing args section without
a setup key, and a pyproject with no args section at all.
"""
import re
import sys

path, args = sys.argv[1], sys.argv[2:]
if not args:
    sys.exit(0)
injected = ", ".join('"%s"' % a for a in args)

lines = open(path).read().split("\n")

header = None
for i, line in enumerate(lines):
    if line.strip() == "[tool.meson-python.args]":
        header = i
        break

if header is None:
    open(path, "a").write(
        "\n[tool.meson-python.args]\nsetup = [%s]\n" % injected
    )
    sys.exit(0)

end = len(lines)
for j in range(header + 1, len(lines)):
    if lines[j].startswith("["):
        end = j
        break

for j in range(header + 1, end):
    match = re.match(r"(\s*setup\s*=\s*\[)([^\]]*)(\])", lines[j])
    if match:
        sep = ", " if match.group(2).strip() else ""
        lines[j] = (
            match.group(1)
            + match.group(2)
            + sep
            + injected
            + match.group(3)
        )
        break
else:
    lines.insert(header + 1, "setup = [%s]" % injected)

open(path, "w").write("\n".join(lines))