#!/bin/bash

DB_BASE='testrail'

DATE=`date '+%Y-%m-%d-%H-%M-%S'`
BACKUP_NAME=testrail-backup-$DATE.tar.gz
BACKUP_DIR=/var/backups/testrail

mkdir -pv $BACKUP_DIR
mysqldump --max-allowed-packet=32M $DB_BASE | gzip -c > $BACKUP_DIR/testrail.sql.gz
cp -rp /var/www/html/testrail/ $BACKUP_DIR/testrail
cp -rp /opt/testrail/attachments/ $BACKUP_DIR/attachments
cp -rp /opt/testrail/reports/ $BACKUP_DIR/reports
tar -zcvf "$BACKUP_NAME" $BACKUP_DIR
aws s3 cp "$BACKUP_NAME" s3://nct-testrail-backup/
rm "$BACKUP_NAME"
rm -rf $BACKUP_DIR
