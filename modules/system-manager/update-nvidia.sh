#!/usr/bin/env nix-shell
#!nix-shell  -i bash -p jq nurl
# shellcheck shell=bash

set -euo pipefail

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
tmp="$(mktemp)"

update() {
    HOST="$1"

    xml="$(ssh "$HOST" nvidia-smi -q -x || true)"
    [[ "$xml" == "NVIDIA-SMI has failed"* ]] && return 0
    test -n "$xml" || return 0

    ver="$(printf '%s' "$xml" | xq -r .nvidia_smi_log.driver_version)"
    test -n "$ver" || return 0

    echo "$HOST has $ver"
    jq ".[\"$HOST\"] = \"$ver\"" "$dir/hosts.json" > "$tmp"
    mv "$tmp" "$dir/hosts.json"

    grep -q "\"$ver\"" "$dir/hashes.json" && return 0

    hash="$(nurl -f fetchurl -H "https://download.nvidia.com/XFree86/Linux-x86_64/$ver/NVIDIA-Linux-x86_64-$ver.run")"

    echo "Adding hash $hash"
    jq ".[\"$ver\"] = \"$hash\"" "$dir/hashes.json" > "$tmp"
    mv "$tmp" "$dir/hashes.json"
}

if [ "$#" -eq "0" ]
then
    HOSTS=$(jq -r keys[] hosts.json)
    for host in $HOSTS
    do
        update "$host"
    done
else
    update "$1"
fi
