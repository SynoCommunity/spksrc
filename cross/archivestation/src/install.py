#!/usr/bin/env python3
"""Stage upstream sources and adapt DSM integration to the spksrc identity."""

import json
import runpy
import shutil
import sys
from pathlib import Path

source, target = map(Path, sys.argv[1:])
packaging = source / "packaging/synology"
target.mkdir(parents=True, exist_ok=True)
shutil.copytree(source / "src/archive_station", target / "app/archive_station", dirs_exist_ok=True)
shutil.copytree(packaging / "ui", target / "ui", dirs_exist_ok=True)
shutil.copytree(source / "src/archive_station/static", target / "ui/web", dirs_exist_ok=True)
shutil.copyfile(source / "LICENSE", target / "LICENSE")
# Reuse the upstream language mapping and notification catalog generation.
runpy.run_path(str(source / "scripts/build_spk.py"))["notification_texts"](target / "ui")


def replace(path, old, new):
    text = path.read_text()
    if old not in text:
        raise ValueError(f"Upstream integration changed: {path}: {old!r}")
    path.write_text(text.replace(old, new))


replace(target / "ui/config", "/3rdparty/ArchiveStation/", "/3rdparty/archivestation/")
replace(target / "ui/gateway.cgi", "/ArchiveStation/target/python/", "/archivestation/target/env/")
(target / "ui/gateway.cgi").chmod(0o755)
replace(
    target / "app/archive_station/notifications.py",
    "ArchiveStation:notifications:",
    "archivestation:notifications:",
)
for web in (target / "ui/web", target / "app/archive_station/static"):
    replace(web / "app.js", "/3rdparty/ArchiveStation/", "/3rdparty/archivestation/")
    replace(web / "index.html", "<b>ArchiveStation</b>", "<b>sc-archivestation</b>")
    # Keep translation keys stable; only the account shown to users changes.
    for path in (web / "locales").glob("*.json"):
        catalog = json.loads(path.read_text())
        catalog = {
            key: value.replace("ArchiveStation", "sc-archivestation")
            if "ArchiveStation" in key
            else value
            for key, value in catalog.items()
        }
        path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n")
    # Package Center owns updates. Upstream's checker offers a different package ID.
    with (web / "style.css").open("a") as stream:
        stream.write("\n#update-settings, #update-available { display: none !important; }\n")
