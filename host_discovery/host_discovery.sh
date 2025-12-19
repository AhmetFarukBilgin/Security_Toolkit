#!/bin/bash

# -----------------------------
# Host Discovery Script
# -----------------------------

usage() {
    echo "Usage:"
    echo "  $0 -t <target|ip_list.txt> -m <method> -s <speed> -o <output_types>"
    echo
    echo "Targets:"
    echo "  CIDR           → 10.10.14.0/23"
    echo "  IP list file   → targets.txt"
    echo
    echo "Methods:"
    echo "  icmp           → ICMP echo (-PE)"
    echo "  tcp            → TCP SYN 80,443 (-PS)"
    echo "  default        → Nmap default discovery"
    echo "  noping         → Ping bypass (-Pn)"
    echo
    echo "Speed:"
    echo "  slow | normal | fast"
    echo
    echo "Output types (comma separated):"
    echo "  ip             → Only live IP list"
    echo "  nmap           → Normal nmap output"
    echo "  grep           → Grepable output"
    echo
    echo "Example:"
    echo "  $0 -t 10.10.14.0/23 -m tcp -s fast -o ip,nmap"
    exit 1
}

# -----------------------------
# Args
# -----------------------------
while getopts "t:m:s:o:" opt; do
    case $opt in
        t) TARGET=$OPTARG ;;
        m) METHOD=$OPTARG ;;
        s) SPEED=$OPTARG ;;
        o) OUTPUTS=$OPTARG ;;
        *) usage ;;
    esac
done

[ -z "$TARGET" ] || [ -z "$METHOD" ] || [ -z "$SPEED" ] || [ -z "$OUTPUTS" ] && usage

# -----------------------------
# Speed Profiles
# -----------------------------
case $SPEED in
    slow)   SPEED_OPTS="-T2" ;;
    normal) SPEED_OPTS="-T3" ;;
    fast)   SPEED_OPTS="-T4 --min-parallelism 100" ;;
    *) echo "Invalid speed"; exit 1 ;;
esac

# -----------------------------
# Discovery Methods
# -----------------------------
case $METHOD in
    icmp)    DISCOVERY="-sn -PE" ;;
    tcp)     DISCOVERY="-sn -PS80,443" ;;
    default) DISCOVERY="-sn" ;;
    noping)  DISCOVERY="-Pn --top-ports 1" ;;
    *) echo "Invalid method"; exit 1 ;;
esac

# -----------------------------
# Target Handling
# -----------------------------
if [[ -f "$TARGET" ]]; then
    TARGET_OPTS="-iL $TARGET"
else
    TARGET_OPTS="$TARGET"
fi

# -----------------------------
# Output directory
# -----------------------------
OUTDIR="$HOME/Desktop/host_discovery_$(date +%F_%H-%M-%S)"
mkdir -p "$OUTDIR"

# -----------------------------
# Run Scan
# -----------------------------
echo "[*] Running host discovery..."
nmap $DISCOVERY $SPEED_OPTS $TARGET_OPTS \
    -oN "$OUTDIR/result.nmap" \
    -oG "$OUTDIR/result.gnmap" >/dev/null

# -----------------------------
# Output Selection
# -----------------------------
IFS=',' read -ra OUTS <<< "$OUTPUTS"

for o in "${OUTS[@]}"; do
    case $o in
        ip)
            grep "Up" "$OUTDIR/result.gnmap" | awk '{print $2}' > "$OUTDIR/hosts.txt"
            echo "[+] IP list saved: hosts.txt"
            ;;
        nmap)
            echo "[+] Nmap output saved: result.nmap"
            ;;
        grep)
            echo "[+] Grepable output saved: result.gnmap"
            ;;
        *)
            echo "Unknown output type: $o"
            ;;
    esac
done

echo "[✓] Done. Results in: $OUTDIR"
