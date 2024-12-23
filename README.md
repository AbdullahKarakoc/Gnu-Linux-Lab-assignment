# Gnu-Linux-Lab Assignment Documentation

This document explains the structure, purpose, and operation of the Gnu-Linux-Lab assignment project. Follow the steps below to understand the implementation, configuration, and usage of the project.

## Project Overview

The project involves parsing Nginx access logs to extract and process specific information, such as the top 10 source IPs and user IDs, and saving the parsed data into a structured format. The process is automated using a combination of Bash scripts, a systemd service, and a cron job.

---

## Project Structure

```
/root/Gnu-Linux-Lab-assignment/
├── create_log.sh         # Script to generate log files
├── stop_log.sh           # Script to stop log processing
├── parse_log.sh          # Script to parse and extract data from logs
├── parsed_logs/          # Directory to store parsed log outputs
├── parse_log.service     # systemd service file for log processing
└── cronjob.txt           # Cron job definition file
```

---

## Prerequisites

1. A Linux system with `bash` and `systemd` installed.
2. Nginx web server with access logs enabled (`/var/log/nginx/access.log`).
3. Root or sudo privileges to manage services and cron jobs.

---

## File Descriptions

### 1. **`create_log.sh`**

This script simulates or triggers log generation.

```bash
#!/bin/bash
# Log generation logic here (e.g., using Nginx or mock data generation).
echo "Log generation started."
```

### 2. **`stop_log.sh`**

This script stops log processing operations.

```bash
#!/bin/bash
# Logic to stop log generation.
echo "Log generation stopped."
```

### 3. **`parse_log.sh`**

This script parses the Nginx access log and extracts the top 10 source IPs and user IDs, saving the results in the `parsed_logs` directory.

```bash
#!/bin/bash
# Log file path
LOG_FILE="/var/log/nginx/access.log"

# Output directory
OUTPUT_DIR="/root/Gnu-Linux-Lab-assignment/parsed_logs"

# Create output directory if not exists
mkdir -p "$OUTPUT_DIR"

# Generate timestamp
TIMESTAMP=$(date '+%d-%m-%Y_%H')
OUTPUT_FILE="$OUTPUT_DIR/$TIMESTAMP.log"

# Extract top 10 IPs
TOP_IPS=$(grep -oE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10)

# Extract top 10 User IDs
TOP_USERS=$(grep -oE 'user[0-9]+' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10)

# Write output to file
{
    echo "Top 10 Source IPs:"
    echo "$TOP_IPS"
    echo
    echo "Top 10 User IDs:"
    echo "$TOP_USERS"
} > "$OUTPUT_FILE"

echo "Parse operation completed. Results saved in: $OUTPUT_FILE"
```

### 4. **`log.service`**

A systemd service file to automate log generation and processing.

```ini
[Unit]
Description=Log Application
After=nginx.service

[Service]
ExecStart=/bin/bash /root/Gnu-Linux-Lab-assignment/create_log.sh
ExecStop=/bin/bash /root/Gnu-Linux-Lab-assignment/stop_log.sh
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
```

### 5. **`parse_log.service`**

A systemd service file to automate parse log generation and processing.

```ini
[Unit]
Description=Parse Log Service
After=network.target

[Service]
ExecStart=/bin/bash /root/Gnu-Linux-Lab-assignment/parse_log.sh
Restart=on-failure
User=root
Group=root

[Install]
WantedBy=multi-user.target
```



### 6. **`cronjob.txt`**

Defines a cron job to periodically run `parse_log.sh` for processing logs.

```txt
0 * * * * /usr/bin/systemctl start log.service
59 * * * * /usr/bin/systemctl stop log.service

0 * * * * /usr/bin/systemctl start parse_log.service
59 * * * * /usr/bin/systemctl stop parse_log.service
```

---

## Installation & Configuration

### Step 1: Place Files in Appropriate Locations

1. Copy the scripts to `/root/Gnu-Linux-Lab-assignment/`.
2. Ensure the `log.service` file is placed in `/etc/systemd/system/`.

### Step 2: Set Permissions

Set execute permissions on all scripts:

```bash
chmod +x /root/Gnu-Linux-Lab-assignment/*.sh
```

### Step 3: Enable and Start the Systemd Service

```bash
sudo systemctl daemon-reload
sudo systemctl enable log.service
sudo systemctl start log.service
sudo systemctl enable parse_log.service
sudo systemctl start parse_log.service
```

### Step 4: Configure Cron Job

Add the cron job from `cronjob.txt` to the crontab:

```bash
crontab -e
# Add the following line
0 * * * * /usr/bin/systemctl start log.service
59 * * * * /usr/bin/systemctl stop log.service

0 * * * * /usr/bin/systemctl start parse_log.service
59 * * * * /usr/bin/systemctl stop parse_log.service```

---

## Testing the Project

### 1. **Check Systemd Service Status**

```bash
sudo systemctl status log.service
sudo systemctl status parse_log.service

```

### 2. **Verify Log Parsing**

Ensure parsed logs are being created in the `parsed_logs` directory:

```bash
ls /root/Gnu-Linux-Lab-assignment/parsed_logs
```

### 3. **Inspect Parsed Log Content**

```bash
cat /root/Gnu-Linux-Lab-assignment/parsed_logs/<timestamp>.log
```

### 4. **Simulate Manual Script Execution**

Manually run `create_log.sh`, `stop_log.sh`, and `parse_log.sh` to verify they work as expected.

```bash
/bin/bash /root/Gnu-Linux-Lab-assignment/create_log.sh
/bin/bash /root/Gnu-Linux-Lab-assignment/stop_log.sh
/bin/bash /root/Gnu-Linux-Lab-assignment/parse_log.sh
```

---

## Troubleshooting

### Common Issues

- **Service Fails to Start**: Check logs using `journalctl -u log.service`.
- **Logs Not Parsed**: Verify the path to the Nginx access log in `parse_log.sh`.
- **Cron Job Not Executing**: Check the cron daemon status using `sudo systemctl status cron`.

### Debugging Tips

- Test each script independently before integrating with the systemd service or cron job.
- Use `echo` statements in scripts to debug and track execution flow.

---

## Conclusion

This project demonstrates a complete automation setup for processing logs in a Linux environment using Bash scripting, systemd services, and cron jobs. By following the steps and configuration details outlined above, you can ensure the system works reliably and meets the requirements of the assignment.
