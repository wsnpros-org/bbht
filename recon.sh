#!/bin/bash
domain=$1
output="results/$domain"
mkdir -p "$output"

echo "[+] Enumerating with Sublist3r"
python3 ~/tools/Sublist3r/sublist3r.py -d $domain -o "$output/sublister.txt"

echo "[+] Probing live hosts"
cat "$output/sublister.txt" | httprobe > "$output/live.txt"

echo "[+] Pulling Wayback URLs"
cat "$output/live.txt" | waybackurls > "$output/wayback.txt"

echo "[+] Running Nuclei"
nuclei -l "$output/live.txt" -o "$output/nuclei.txt"

echo "[+] Done. Results saved in $output/"
