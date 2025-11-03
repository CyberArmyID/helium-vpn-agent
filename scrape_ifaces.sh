#!/usr/bin/env bash

set -euo pipefail

OUTPUT_DIR="data"
OUTPUT_FILE="$OUTPUT_DIR/host_interfaces.json"
mkdir -p "$OUTPUT_DIR"

EXCLUDE_REGEX="^(docker|veth|br-|lo|tun|tap|virbr|vbox|vmnet|tailscale|wg|zt|podman|hg-)"

OS_TYPE="$(uname -s)"
if [[ "$OS_TYPE" == "Linux" ]]; then
    SYSTEM="linux"
elif [[ "$OS_TYPE" == "Darwin" ]]; then
    SYSTEM="darwin"
else
    echo "[ERROR] Unsupported OS: $OS_TYPE"
    exit 1
fi

collect_linux() {
    ip -o -4 addr show | awk -v excl="$EXCLUDE_REGEX" '
    !($2 ~ excl) {
        iface=$2
        split($4, a, "/")
        ip=a[1]; prefix=a[2]
        printf("{\"type\":\"host\",\"subnet\":\"%s/%s\",\"name\":\"%s\"}\n", ip, prefix, iface)
    }'
}

collect_darwin() {
    ifconfig | awk -v excl="$EXCLUDE_REGEX" '
    /^[a-zA-Z0-9]/ {
        iface=$1
        sub(":", "", iface)
    }
    $1=="inet" && !(iface ~ excl) {
        ip=$2; mask=$4
        # Convert hex netmask like 0xffffff00 to prefix manually
        if (mask ~ /^0x/) {
            maskhex=substr(mask,3)
            # convert hex mask to decimal bits count
            bits=0
            for (i=1; i<=8; i+=2) {
                hexbyte=substr(maskhex,i,2)
                cmd="printf \"%d\" 0x" hexbyte
                cmd | getline val
                close(cmd)
                while (val>0) { bits += val % 2; val=int(val/2) }
            }
            prefix=bits
        } else {
            # fallback if netmask already dotted
            cmd="ipcalc -p " ip " " mask " 2>/dev/null"
            cmd | getline prefixline
            close(cmd)
            sub("PREFIX=", "", prefixline)
            prefix=prefixline
            if (prefix == "") prefix="24"
        }
        printf("{\"type\":\"host\",\"subnet\":\"%s/%s\",\"name\":\"%s\"}\n", ip, prefix, iface)
    }'
}

json_lines=""
if [[ "$SYSTEM" == "linux" ]]; then
    json_lines=$(collect_linux)
elif [[ "$SYSTEM" == "darwin" ]]; then
    json_lines=$(collect_darwin)
fi

if [[ -z "$json_lines" ]]; then
    echo "[]" > "$OUTPUT_FILE"
    echo "[WARN] No host interfaces found. Wrote empty JSON to $OUTPUT_FILE"
else
    json_array=$(echo "$json_lines" | jq -s '.')
    echo "$json_array" > "$OUTPUT_FILE"
    echo "[OK] Saved host interfaces to $OUTPUT_FILE"
fi
