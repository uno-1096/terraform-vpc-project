#!/bin/bash
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_BUCKET="s3://unocloud-homelab-backup/nextcloud"

echo "[$TIMESTAMP] Starting Nextcloud backup..." >> /var/log/nextcloud-backup.log

# Sync Nextcloud data to S3
aws s3 sync /var/lib/docker/volumes/nextcloud_nextcloud_data/_data \
  $BACKUP_BUCKET/data \
  --delete >> /var/log/nextcloud-backup.log 2>&1

echo "[$TIMESTAMP] Backup complete." >> /var/log/nextcloud-backup.log
