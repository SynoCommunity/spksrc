#!/usr/bin/env python3
import os
import sys
import re
import zipfile

def extract_metadata(wheel_path):
    """
    Extract the package name and version from the wheel's METADATA.
    Returns (name, version) if found; otherwise (None, None).
    """
    try:
        with zipfile.ZipFile(wheel_path, 'r') as zf:
            # Locate the METADATA file (inside the .dist-info directory)
            metadata_file = next((f for f in zf.namelist() if f.endswith("METADATA")), None)
            if not metadata_file:
                return None, None
            metadata = zf.read(metadata_file).decode("utf-8")
            name_match = re.search(r'^Name:\s*(\S+)', metadata, re.MULTILINE)
            version_match = re.search(r'^Version:\s*(\S+)', metadata, re.MULTILINE)
            if name_match and version_match:
                pkg_name = name_match.group(1)
                pkg_version = version_match.group(1)
                return pkg_name, pkg_version
    except Exception as e:
        print(f"Error processing {wheel_path}: {e}")
    return None, None

def main(wheelhouse_dir, req_file_path):
    # Build a mapping from version -> set of package names found in wheels
    wheel_map = {}
    for filename in os.listdir(wheelhouse_dir):
        if filename.endswith(".whl"):
            full_path = os.path.join(wheelhouse_dir, filename)
            pkg_name, pkg_version = extract_metadata(full_path)
            if pkg_name and pkg_version:
                if pkg_version not in wheel_map:
                    wheel_map[pkg_version] = set()
                wheel_map[pkg_version].add(pkg_name)

    if not wheel_map:
        print("No wheel metadata found in the wheelhouse.")
        sys.exit(0)

    print("Detected wheel metadata:")
    for ver, names in wheel_map.items():
        print(f"  Version {ver} -> Packages {', '.join(names)}")

    # Open and read the requirements file
    if not os.path.isfile(req_file_path):
        print(f"Requirements file {req_file_path} not found.")
        sys.exit(1)

    with open(req_file_path, "r") as f:
        lines = f.readlines()

    # Regex to match lines like "package==version"
    req_pattern = re.compile(r"^(?P<pkg>[^=]+)==(?P<ver>.+)$")
    new_lines = []
    for line in lines:
        stripped = line.strip()
        # Leave blank lines and comments unchanged
        if not stripped or stripped.startswith("#"):
            new_lines.append(line)
            continue

        m = req_pattern.match(stripped)
        if m:
            req_pkg = m.group("pkg")
            req_ver = m.group("ver")
            # Check if wheels in the wheelhouse report this version
            if req_ver in wheel_map:
                candidates = wheel_map[req_ver]
                # If the current requirements file already matches one candidate, leave it
                if req_pkg in candidates:
                    new_lines.append(line)
                    continue
                else:
                    # If there's exactly one candidate, update the requirements entry
                    if len(candidates) == 1:
                        actual_name = list(candidates)[0]
                        print(f"Correcting entry '{req_pkg}=={req_ver}' to '{actual_name}=={req_ver}'")
                        new_lines.append(f"{actual_name}=={req_ver}\n")
                        continue
                    else:
                        # Ambiguous candidates exist, so we log a warning and leave the entry unchanged.
                        print(f"Ambiguous candidates for version {req_ver}: {', '.join(candidates)}. "
                              f"Entry '{req_pkg}=={req_ver}' remains unchanged.")
                        new_lines.append(line)
                        continue
            else:
                new_lines.append(line)
        else:
            new_lines.append(line)

    # Overwrite the requirements file with the updated content
    with open(req_file_path, "w") as f:
        f.writelines(new_lines)
    print(f"Updated requirements file: {req_file_path}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: fix_requirements.py <wheelhouse_directory> <requirements_file>")
        sys.exit(1)
    wheelhouse_dir = sys.argv[1]
    req_file_path = sys.argv[2]
    main(wheelhouse_dir, req_file_path)
