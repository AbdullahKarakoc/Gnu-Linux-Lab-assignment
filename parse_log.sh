#!/bin/bash

# Log dosyası yolu
LOG_FILE="/var/log/nginx/access.log"

# Çıktıların kaydedileceği dizin
OUTPUT_DIR="/root/Gnu-Linux-Lab-assignment/parsed_logs"

# Çıktı dosyasını oluştur
timestamp=$(date '+%d-%m-%Y_%H-%M')
OUTPUT_FILE="$OUTPUT_DIR/parsed_log_$timestamp.log"

# Dizini oluştur (eğer yoksa)
mkdir -p "$OUTPUT_DIR"

# İlk 10 IP adresini al
TOP_IPS=$(grep -oE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10)

# İlk 10 User ID'yi al
TOP_USERS=$(grep -oE 'user[0-9]+' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10)

# Çıktıyı dosyaya yaz
{
    echo "====================="
    echo "Top 10 Source IPs:"
    echo "====================="
    if [ -z "$TOP_IPS" ]; then
        echo "Veri bulunamadı."
    else
        echo "$TOP_IPS"
    fi
    echo
    echo "====================="
    echo "Top 10 User IDs:"
    echo "====================="
    if [ -z "$TOP_USERS" ]; then
        echo "Veri bulunamadı."
    else
        echo "$TOP_USERS"
    fi
} > "$OUTPUT_FILE"

echo "Parse işlemi tamamlandı. Sonuçlar: $OUTPUT_FILE"

