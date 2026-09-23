#!/bin/bash

BASE="192.168"
INICIO=1
FIM=254
DIR="resultados_nmap"

mkdir -p "$DIR"

for RANGE in $(seq "$INICIO" "$FIM"); do

    REDE="$BASE.$RANGE.0/24"
    ARQUIVO="$DIR/$BASE.$RANGE.txt"

    echo "[+] Varrendo $REDE"

    # Cabeçalho
    {
        echo "REDE: $REDE"
        echo "DATA: $(date '+%Y-%m-%d %H:%M:%S')"
        echo
        printf "%-16s %-18s %s\n" "IP" "MAC" "HOSTNAME"
        printf "%-16s %-18s %s\n" "----------------" "-----------------" "-------------------------"
    } > "$ARQUIVO"

    # -sn  = descoberta de hosts, sem port scan
    # -PR  = ARP discovery quando aplicável
    # -n   = não fazer reverse DNS
    nmap -sn -PR "$REDE" -oG - 2>/dev/null |
    awk '
    /^Host:/ {
        ip=$2
        mac=""
        hostname=""
        
        for (i=3; i<=NF; i++) {
            if ($i ~ /^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$/)
                mac=$i
        }

        if ($0 ~ /\(/) {
            hostname=$0
            sub(/^.*\(/, "", hostname)
            sub(/\).*/, "", hostname)
        }

        printf "%-16s %-18s %s\n", ip, mac, hostname
    }
    ' >> "$ARQUIVO"

    # Se não encontrou nenhum host além do cabeçalho
    if [ "$(wc -l < "$ARQUIVO")" -le 4 ]; then
        echo "Nenhum host encontrado." >> "$ARQUIVO"
    fi

done

echo
echo "[+] Varredura concluída."
echo "[+] Resultados salvos em: $DIR/"
