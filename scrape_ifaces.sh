#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="data"
OUTPUT_FILE="$OUTPUT_DIR/host_interfaces.json"

mkdir -p "$OUTPUT_DIR"

EXCLUDE_REGEX="^(docker|veth|br-|lo|tun|tap|virbr|wlxdocker|vbox|vmnet|tailscale|wg|zt|podman|hg-)"

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
    /^[a-zA-Z0-9]/ { iface=$1; sub(":", "", iface) }
    $1=="inet" && !(iface ~ excl) {
        ip=$2; mask=$4
        # Convert hex mask to dotted decimal
        if (mask ~ /^0x/) {
            maskhex=substr(mask,3)
            split(maskhex, a, "")
            dec=""
            for (i=1; i<=length(maskhex); i+=2) {
                dec=dec strtonum("0x" substr(maskhex,i,2)) "."
            }
            sub(/\.$/, "", dec)
            mask=dec
        }
        cmd="ipcalc -p " ip " " mask " 2>/dev/null"
        cmd | getline prefix
        close(cmd)
        sub("PREFIX=", "", prefix)
        if (prefix == "") prefix="24"
        printf("{\"type\":\"host\",\"subnet\":\"%s/%s\",\"name\":\"%s\"}\n", ip, prefix, iface)
    }'
}

collect_interfaces() {
    local system
    system=$(uname -s)
    if [[ "$system" == "Linux" ]]; then
        collect_linux
    elif [[ "$system" == "Darwin" ]]; then
        collect_darwin
    else
        echo "Unsupported OS: $system" >&2
        exit 1
    fi
}

json_lines=$(collect_interfaces)

json_array=$(echo "$json_lines" | jq -s '.')

echo "$json_array" > "$OUTPUT_FILE"

echo "Saved host interfaces to $OUTPUT_FILE"
