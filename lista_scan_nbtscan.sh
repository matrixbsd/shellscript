#!/bin/bash

# Scan simples usando o nbtscan para criar listas com ips encontrados, de acordo com o range.

BASE="192.168"
INICIO=1
FIM=254
DIR="resultados"

mkdir -p "$DIR"

for RANGE in $(seq "$INICIO" "$FIM"); do
    REDE="$BASE.$RANGE.0/24"
    ARQUIVO="$DIR/$BASE.$RANGE.txt"

    echo "[+] Varrendo $REDE"

    nbtscan "$REDE" > "$ARQUIVO"

    if [ ! -s "$ARQUIVO" ]; then
        echo "Nenhum host encontrado." > "$ARQUIVO"
    fi
done

echo
echo "[+] Varredura concluída."
echo "[+] Resultados em: $DIR/"
