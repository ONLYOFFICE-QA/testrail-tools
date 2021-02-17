#!/bin/bash

AWS_ACCESS_KEY_ID=''
AWS_SECRET_ACCESS_KEY=''
BACKUP_NAME=''
TESTRAIL_DB_USER=''
TESTRAIl_DB_PASS=''
TEMP_FOLDER='/tmp'

PHP_MAJOR_VERSION='7'
PHP_MINOR_VERSION='2'

sudo apt-get -y update
sudo apt-get -y install awscli \
                        certbot \
                        cron \
                        curl \
                        fail2ban \
                        libfontconfig1 \
                        mysql-server \
                        php \
                        php-curl \
                        php-mbstring \
                        php-mysql \
                        php-xml \
                        pv \
                        unzip \
                        wget

# Install ioncube loader
wget -P /tmp https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar xvf /tmp/ioncube_loaders_lin_x86-64.tar.gz -C /opt
rm -rf /tmp/ioncube_loaders_lin_x86-64.tar.gz
echo "zend_extension=/opt/ioncube/ioncube_loader_lin_${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}.so" > /etc/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}/apache2/php.ini
echo "zend_extension=/opt/ioncube/ioncube_loader_lin_${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}.so" > /etc/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}/cli/php.ini

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws s3 cp s3://nct-testrail-backup/$BACKUP_NAME $TEMP_FOLDER

# Unpack backup
tar xvf $TEMP_FOLDER/$BACKUP_NAME -C $TEMP_FOLDER
mkdir /opt/testrail
mv $TEMP_FOLDER/var/backups/testrail/testrail /var/www/html
mv $TEMP_FOLDER/var/backups/testrail/attachments /opt/testrail/attachments
mv $TEMP_FOLDER/var/backups/testrail/reports /opt/testrail/reports

# Restore database
service mysql start
mysql -u root -e 'CREATE DATABASE testrail DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;'
mysql -u root -e "CREATE USER 'testrail'@'localhost' IDENTIFIED BY '$TESTRAIl_DB_PASS';"
mysql -u root -e "GRANT ALL ON testrail.* TO 'testrail'@'localhost';"
pv $TEMP_FOLDER/var/backups/testrail/testrail.sql.gz | gunzip | mysql -u $TESTRAIL_DB_USER -p$TESTRAIl_DB_PASS testrail

# Add cron task for background tasks
echo "* * * * * www-data /usr/bin/php /var/www/html/testrail/task.php" > /etc/cron.d/testrail
service apache2 restart
