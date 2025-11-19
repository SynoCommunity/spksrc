#!/usr/bin/env python3
"""
Generate Dependabot configuration for Python requirements files.
Scans the repository for requirements.txt files and creates a consolidated
dependabot.yml configuration with grouped updates.

HOWTO - Manual Testing:
-----------------------
1. Run the script from repository root:
   $ cd /path/to/your/repo
   $ python3 .github/actions/update_python_requirements.py

2. Verify the output:
   $ cat .github/dependabot.yml
   
   Check that:
   - Paths start with "/" (e.g., /spk/python311/src)
   - All expected requirements files are included
   - YAML structure looks correct

3. Validate YAML syntax:
   $ python3 -c "import yaml; yaml.safe_load(open('.github/dependabot.yml'))"
   $ echo $?  # Should output: 0 (success)

4. (Optional) View found files during execution:
   Temporarily uncomment the debug line in generate_dependabot_config()
   to see which requirements files were discovered.

Requirements:
-------------
- Python 3.x
- PyYAML: pip install PyYAML
"""
import os
import glob
import itertools
import yaml

def find_repo_root(start_path):
    """
    Find the repository root by looking for common indicators
    like .git directory or spksrc directory.
    """
    current_path = os.path.abspath(start_path)
    
    while current_path != os.path.dirname(current_path):
        if os.path.isdir(os.path.join(current_path, '.git')):
            return current_path
        
        if os.path.isdir(os.path.join(current_path, 'spksrc')):
            return current_path
            
        for indicator in ['.gitignore', 'README.md', 'LICENSE']:
            if os.path.isfile(os.path.join(current_path, indicator)):
                if os.path.isdir(os.path.join(current_path, 'spksrc')):
                    return current_path
        
        current_path = os.path.dirname(current_path)
    
    raise RuntimeError("Could not find repository root")


# Configuration
IGNORED_PACKAGES = ["pip", "Cython", "msgpack"]

REQUIREMENTS_PATTERNS = [
    "spk/python*/crossenv/requirements-default.txt",
    "spk/python*/src/requirements-abi3.txt",
    "spk/python*/src/requirements-crossenv.txt", 
    "spk/python*/src/requirements-pure.txt",
    "native/python*/src/requirements.txt"
]


def create_ignore_list(packages):
    """Create the ignore list for Dependabot configuration."""
    ignore_list = []
    for package in packages:
        ignore_list.append({
            "dependency-name": package,
            "update-types": [
                "version-update:semver-major",
                "version-update:semver-minor",
                "version-update:semver-patch"
            ]
        })
    return ignore_list


def generate_dependabot_config(repo_root):
    """
    Generate Dependabot configuration by scanning for Python requirements files.
    
    Returns:
        dict: Dependabot configuration structure
    """
    # Find all requirements files
    paths = itertools.chain.from_iterable(
        glob.glob(os.path.join(repo_root, pattern)) 
        for pattern in REQUIREMENTS_PATTERNS
    )
    
    updates = []
    requirements_found = []
    
    for req_file in paths:
        requirements_found.append(req_file)
        filename = os.path.basename(req_file)
        
        # CRITICAL: Dependabot requires relative path from repo root with leading "/"
        relative_dir = "/" + os.path.relpath(os.path.dirname(req_file), repo_root)
        
        updates.append({
            "package-ecosystem": "pip",
            "directory": relative_dir,
            "requirements-file": filename,
            "schedule": {
                "interval": "weekly"
            },
            "groups": {
                "all-python-deps": {
                    "patterns": ["*"]
                }
            },
            "ignore": create_ignore_list(IGNORED_PACKAGES)
        })
    
    return {
        "version": 2,
        "updates": updates
    }, requirements_found


def main():
    """Main execution function."""
    # Find repository root
    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_root = find_repo_root(script_dir)
    
    print(f"Repository root: {repo_root}")
    
    # Generate configuration
    dependabot_config, requirements_found = generate_dependabot_config(repo_root)
    
    print(f"Found {len(requirements_found)} requirements files")
    if len(requirements_found) == 0:
        print("WARNING: No requirements files found. Check REQUIREMENTS_PATTERNS.")
        return
    
    # Write configuration
    output_path = os.path.join(repo_root, ".github", "dependabot.yml")
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    with open(output_path, "w") as f:
        yaml.dump(dependabot_config, f, sort_keys=False, default_flow_style=False, indent=2)
    
    print(f"Generated dependabot.yml with {len(dependabot_config['updates'])} update configurations")
    print(f"Output: {output_path}")


if __name__ == "__main__":
    main()
