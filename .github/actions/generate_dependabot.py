#!/usr/bin/env python3
import os
import glob
import itertools
import yaml

def find_repo_root(start_path):
    """
    Find the repository root by looking for common indicators
    like .git directory or spksrc directory
    """
    current_path = os.path.abspath(start_path)
    
    while current_path != os.path.dirname(current_path):  # Not at filesystem root
        # Check for .git directory (most reliable)
        if os.path.isdir(os.path.join(current_path, '.git')):
            return current_path
        
        # Check for spksrc directory (specific to your project)
        if os.path.isdir(os.path.join(current_path, 'spksrc')):
            return current_path
            
        # Check for common project files
        for indicator in ['.gitignore', 'README.md', 'LICENSE']:
            if os.path.isfile(os.path.join(current_path, indicator)):
                # Verify spksrc exists at this level
                if os.path.isdir(os.path.join(current_path, 'spksrc')):
                    return current_path
        
        current_path = os.path.dirname(current_path)
    
    raise RuntimeError("Could not find repository root")

# Find absolute directory path of the script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Find the repository root dynamically
repo_root = find_repo_root(script_dir)

# The repository root IS the spksrc root (no subdirectory needed)
spksrc_root = repo_root

# Debug information
# print(f"🔍 Script location: {script_dir}")
# print(f"🔍 Repository root: {repo_root}")
# print(f"🔍 spksrc root: {spksrc_root}")

# Verify key directories exist
# test_dirs = ["spk", "native"]
# for test_dir in test_dirs:
#     test_path = os.path.join(spksrc_root, test_dir)
#     if os.path.isdir(test_path):
#         print(f"✅ Found directory: {test_path}")
#     else:
#         print(f"❌ Missing directory: {test_path}")

globs = [
    "spk/python*/crossenv/requirements-default.txt",
    "spk/python*/src/requirements-abi3.txt",
    "spk/python*/src/requirements-crossenv.txt", 
    "spk/python*/src/requirements-pure.txt",
    "native/python*/src/requirements.txt"
]

# Test glob patterns to see what they find
# print(f"\n🔍 Testing glob patterns:")
# for pattern in globs:
#     full_pattern = os.path.join(spksrc_root, pattern)
#     matches = glob.glob(full_pattern)
#     print(f"   Pattern: {pattern}")
#     print(f"   Full path: {full_pattern}")
#     print(f"   Matches: {len(matches)}")
#     if matches:
#         for match in matches[:3]:  # Show first 3 matches
#             print(f"      - {match}")
#         if len(matches) > 3:
#             print(f"      ... and {len(matches) - 3} more")
#     print()

# Iterate on each glob patterns based on spksrc_root
paths = itertools.chain.from_iterable(
    glob.glob(os.path.join(spksrc_root, pattern)) for pattern in globs
)

updates = []
# found_files = []  # For debugging

for req_file in paths:
    # found_files.append(req_file)
    filename = os.path.basename(req_file)
    
    # Debug: show path calculation
    # print(f"🔍 Processing: {req_file}")
    # print(f"   Relative to repo_root: {os.path.relpath(req_file, repo_root)}")
    # print(f"   Directory (absolute): {os.path.dirname(req_file)}")
    # print(f"   Filename: {filename}")

    updates.append({
        "package-ecosystem": "pip",
        "directory": os.path.dirname(req_file),
        "requirements-file": filename,
        "schedule": {
            "interval": "weekly"
        },
        "groups": {
            "all-python-deps": {
                "patterns": ["*"]
            }
        }
    })

# Debug information
# print(f"🔍 Found {len(found_files)} requirements files:")
# for file in found_files:
#     print(f"   - {file}")

# print(f"🔍 Generated {len(updates)} dependabot updates")

dependabot_config = {
    "version": 2,
    "updates": updates
}

# Relative output to .github/dependabot.yml
output_path = os.path.join(repo_root, ".github", "dependabot.yml")
os.makedirs(os.path.dirname(output_path), exist_ok=True)

# Write the configuration
with open(output_path, "w") as f:
    yaml.dump(dependabot_config, f, sort_keys=False, default_flow_style=False, indent=2)

print(f"✅ dependabot.yml generated at: {output_path}")

# Show a preview of the generated content
# print("\n📋 Generated content preview:")
# print("=" * 50)
# with open(output_path, "r") as f:
#     content = f.read()
#     print(content[:500] + ("..." if len(content) > 500 else ""))
# print("=" * 50)
