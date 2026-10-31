#!/bin/bash
# Generate pinned requirements-pure.txt and requirements-crossenv.txt files.
# Part of SynoCommunity/spksrc.
#
# Copyright (c) 2026 SynoCommunity
# SPDX-License-Identifier: BSD-3-Clause
# See LICENSE.md in the repository root.
set -euo pipefail

usage() {
    cat <<EOF
create requirements files for the given package and python version.

usage: $(basename "$0") [--repo PATH] [--output-dir DIR] package[==version] [310|311|312|313|314]

  package        pip requirement(s), or "-r requirements.txt"
  --repo PATH    spksrc repository root (default: auto-detect from current directory)
  --output-dir   directory for generated_requirements_*.txt (default: current directory)
EOF
}

die() {
    echo "ERROR: $*" >&2
    exit 1
}

_repo=${SPKSRC:-}
_output_dir=.

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        --repo)
            [ "$#" -ge 2 ] || die "--repo requires a path"
            _repo=$2
            shift 2
            ;;
        --output-dir)
            [ "$#" -ge 2 ] || die "--output-dir requires a path"
            _output_dir=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            break
            ;;
    esac
done

if [ "$#" -eq 3 ] && [ "$1" = "-r" ]; then
    _package="-r $2"
    _pip_args=(-r "$2")
    _python_version=$3
elif [ "$#" -eq 2 ]; then
    _package=$1
    read -r -a _pip_args <<< "$_package"
    _python_version=$2
else
    usage >&2
    exit 1
fi

case "$_python_version" in
    310|311|312|313|314)
        ;;
    *)
        die "unexpected python version [$_python_version]"
        ;;
esac

_python=python${_python_version}

find_repo() {
    local dir=$PWD
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/mk/spksrc.common.mk" ]; then
            printf '%s\n' "$dir"
            return 0
        fi
        dir=$(dirname "$dir")
    done
    return 1
}

if [ -z "$_repo" ]; then
    _repo=$(find_repo) || die "cannot locate the spksrc repository; use --repo PATH"
fi

_repo=$(realpath "$_repo")
[ -d "$_repo/cross/$_python" ] || die "cross/$_python not found in $_repo"
[ -d "$_repo/native/$_python" ] || die "native/$_python not found in $_repo"

_native_python="$_repo/native/$_python"
if [ ! -d "$_native_python/work-native" ]; then
    echo "build native python in [$_native_python]."
    make -C "$_native_python"
fi

_python3="$_native_python/work-native/install/usr/local/bin/python3"
[ -x "$_python3" ] || die "native python executable is not available [$_python3]."
_python3=$(realpath "$_python3")

mkdir -p "$_output_dir"
_output_dir=$(realpath "$_output_dir")

echo "python = $_python3"

_venv=$(mktemp -d "${TMPDIR:-/tmp}/generate-requirements.XXXXXX")
_meta=$(mktemp "${TMPDIR:-/tmp}/generate-requirements-meta.XXXXXX")
_python_provided=$(mktemp "${TMPDIR:-/tmp}/generate-requirements-python.XXXXXX")

cleanup() {
    rm -rf "$_venv" "$_meta" "$_python_provided"
}
trap cleanup EXIT

echo "create virtual env [$_venv]"
"$_python3" -m venv "$_venv"

echo "install package [$_package]"
PIP_DISABLE_PIP_VERSION_CHECK=1 "$_venv/bin/python" -m pip install --no-input "${_pip_args[@]}"

_all="$_output_dir/generated_requirements_all.txt"
_crossenv="$_output_dir/generated_requirements_crossenv.txt"
_pure="$_output_dir/generated_requirements_pure.txt"

"$_venv/bin/python" - "$_meta" <<'PY'
import importlib.metadata as metadata
import sys

with open(sys.argv[1], "w") as output:
    for dist in metadata.distributions():
        name = dist.metadata.get("Name")
        if not name:
            continue
        wheel = dist.read_text("WHEEL") or ""
        pure = any(
            line.strip().lower() == "root-is-purelib: true"
            for line in wheel.splitlines()
        )
        output.write(f"{'pure' if pure else 'crossenv'}\t{name}=={dist.version}\n")
PY

LC_ALL=C sort -f -t $'\t' -k2,2 -u "$_meta" -o "$_meta"

_python_requirements="$_repo/spk/$_python/src/requirements-pure.txt"
if [ ! -f "$_python_requirements" ]; then
    _python_requirements="$_repo/spk/$_python-wheels/src/requirements-pure.txt"
fi

if [ -f "$_python_requirements" ]; then
    awk '
        /^[[:space:]]*#/ { next }
        /^[[:space:]]*$/ { next }
        {
            line = $0
            sub(/[[:space:]]*#.*/, "", line)
            sub(/[[:space:]].*/, "", line)
            sub(/\[.*/, "", line)
            sub(/[<>=!~;].*/, "", line)
            gsub(/_/, "-", line)
            print tolower(line)
        }
    ' "$_python_requirements" | LC_ALL=C sort -u > "$_python_provided"
else
    : > "$_python_provided"
fi

printf '%s\n' pip setuptools wheel >> "$_python_provided"
LC_ALL=C sort -u -o "$_python_provided" "$_python_provided"

write_header() {
    local file=$1
    {
        printf '# Generated using the requirements script on %s\n' "$(LC_ALL=C date '+%B %-d, %Y')"
        printf '# Command: %s "%s" %s\n\n' "$(basename "$0")" "$_package" "$_python_version"
    } > "$file"
}

write_header "$_all"
"$_venv/bin/python" -m pip freeze | LC_ALL=C sort -f >> "$_all"

write_requirements() {
    local kind=$1
    local file=$2
    local kind_req
    local req
    local name
    local normalized

    write_header "$file"
    while IFS=$'\t' read -r kind_req req; do
        [ "$kind_req" = "$kind" ] || continue
        name=${req%%==*}
        normalized=$(printf '%s' "$name" | tr '[:upper:]_' '[:lower:]-')
        if grep -Fxq "$normalized" "$_python_provided"; then
            printf '#%-30s ==> %s\n' "$req" "$_python"
        else
            printf '%s\n' "$req"
        fi
    done < "$_meta" >> "$file"
}

write_requirements crossenv "$_crossenv"
write_requirements pure "$_pure"

echo "created:"
printf '  %s\n' "$_all" "$_crossenv" "$_pure"
echo "done."
