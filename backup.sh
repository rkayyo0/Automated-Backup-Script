#!/bin/bash

#Prompt for the source directory/file to backup
echo "Please input the path of the directory or file you wish to backup:"
read -r BACKUP_SRC

#Validate the source path
if [ ! -e "$BACKUP_SRC" ]; then
  echo "Error: The path '$BACKUP_SRC' does not exist."
  exit 1
fi

#Prompt for the prefix for the backup file
echo "Please input the prefix to the name of the backup file:"
read -r BACKUP_PREFIX

#Prompt for Number of Retention Days
echo "Please input the number of days youd like this backup to be retained for"
read -r RETENTION_DAYS

#Ensure Positive Number of Retention Days
if ! [[ "$RETENTION_DAYS" =~ ^[0-9]+$ ]]; then 
  echo "Error: Retention Period Must Be a Positive Number (in days)"
  exit 1
fi 

#Define Variables
BACKUP_DST="/home/rkayyo/backups"
BACKUP_DATE=$(date +%Y-%m-%d-%H%M)
BACKUP_SUBDIR="$BACKUP_DST/${BACKUP_PREFIX}_${BACKUP_DATE}"
BACKUP_FILENAME="${BACKUP_DATE}_RET${RETENTION_DAYS}.tar.gz"
BACKUP_PATH="$BACKUP_SUBDIR/$BACKUP_FILENAME"

#Create the backup directory
mkdir -p "$BACKUP_SUBDIR"

#Archive the source directory/file
tar -czf "$BACKUP_PATH" "$BACKUP_SRC"

#Verify if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup successful: $BACKUP_PATH"
else
  echo "Backup failed. Check for errors in the source or destination paths."
  exit 2
fi
