#!/bin/bash

CLEANUP_DIR="/home/rkayyo/backups"
LOG_FILE="/home/rkayyo/backups/backup_cleanup.log"
DATE="$(date +%Y-%m-%d-%H%M)"

#Start Cleanup
echo "Starting Cleanup ${DATE}" >> "backup_cleanup.log"

#Iterate Through Backup Files
find "$CLEANUP_DIR" -type f -name "*.tar.gz" | while read -r FILE; do
  #Extract Retention Days From FILE
  RETENTION_DAYS=$(echo "$FILE" | grep -oP 'RET\K[0-9]+')
  if [ -z "$RETENTION_DAYS" ]; then
    echo " ${DATE} Retention Days of File ${FILE} Unknown. Skipping..." >> "backup_cleanup.log"
    continue
  fi
  
  #Get the file creation date
  FILE_DATE=$(stat -c %Y "$FILE")
  CURRENT_DATE=$(date +%s)

  #Calculate file age in days
  FILE_AGE=$(( (CURRENT_DATE - FILE_DATE) / 86400 ))
  
  #Check If The File Is Past Its Retention Date
  if [ "$FILE_AGE" -gt "$RETENTION_DAYS" ]; then
    echo "[$(date)] Deleting $FILE (Age: $FILE_AGE days, Retention: $RETENTION_DAYS days)." >> "$LOG_FILE"
    rm -v "$FILE" >> "$LOG_FILE" 2>&1
  else
    echo "[$(date)] Retaining $FILE (Age: $FILE_AGE days, Retention: $RETENTION_DAYS days)." >> "$LOG_FILE"
  fi
done

echo "[$(date)] Cleanup completed." >> "$LOG_FILE"
    
