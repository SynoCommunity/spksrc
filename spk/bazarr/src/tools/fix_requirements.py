#!/usr/bin/env python3
import os
import sys
import re
import zipfile

def extract_metadata(wheel_path):
    """Extract the package name and version from the wheel’s METADATA."""
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
                return name_match.group(1), version_match.group(1)
    except Exception as e:
        print(f"Error processing {wheel_path}: {e}")
    return None, None

def main(wheelhouse_dir, req_file_path):
    # Build a mapping: version -> actual package name (based on METADATA)
    wheel_map = {}
    for filename in os.listdir(wheelhouse_dir):
        if filename.endswith(".whl"):
            full_path = os.path.join(wheelhouse_dir, filename)
            pkg_name, pkg_version = extract_metadata(full_path)
            if pkg_name and pkg_version:
                # For uniqueness assume the version appears only once.
                wheel_map[pkg_version] = pkg_name

    if not wheel_map:
        print("No wheel metadata found in the wheelhouse.")
        sys.exit(0)

    print("Detected wheel metadata:")
    for ver, name in wheel_map.items():
        print(f"  Version {ver} -> Package {name}")

    # Read and process the requirements file.
    if not os.path.isfile(req_file_path):
        print(f"Requirements file {req_file_path} not found.")
        sys.exit(1)

    with open(req_file_path, "r") as f:
        lines = f.readlines()

    req_pattern = re.compile(r"^(?P<pkg>[^=]+)==(?P<ver>.+)$")
    new_lines = []
    for line in lines:
        stripped = line.strip()
        # Leave blank lines or comments unchanged.
        if not stripped or stripped.startswith("#"):
            new_lines.append(line)
            continue

        m = req_pattern.match(stripped)
        if m:
            entry_pkg = m.group("pkg")
            entry_ver = m.group("ver")
            # If there's a wheel with this version, check its actual name.
            if entry_ver in wheel_map:
                actual_name = wheel_map[entry_ver]
                if actual_name != entry_pkg:
                    print(f"Correcting entry '{entry_pkg}=={entry_ver}' to '{actual_name}=={entry_ver}'")
                    new_lines.append(f"{actual_name}=={entry_ver}\n")
                    continue
        new_lines.append(line)

    # Overwrite the original requirements file.
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
