AWS_ACCESS_KEY_ID=''
AWS_SECRET_ACCESS_KEY=''
BACKUP_NAME=''
TESTRAIL_DB_USER=''
TESTRAIl_DB_PASS=''

PHP_MAJOR_VERSION='7'
PHP_MINOR_VERSION='2'

sudo apt-get -y update
sudo apt-get -y install awscli \
                        curl \
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

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws s3 cp s3://nct-testrail-backup/$BACKUP_NAME /tmp

# Unpack backup
tar xvf $BACKUP_NAME
mkdir /opt/testrail
mv /tmp/var/backups/testrail/testrail /var/www/html
mv /tmp/var/backups/testrail/attachments /opt/testrail/attachments
mv /tmp/var/backups/testrail/reports /opt/testrail/reports

# Restore database
service mysql start
mysql -u root -e 'CREATE DATABASE testrail DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;'
mysql -u root -e "CREATE USER 'testrail'@'localhost' IDENTIFIED BY '$TESTRAIl_DB_PASS';"
mysql -u root -e "GRANT ALL ON testrail.* TO 'testrail'@'localhost';"
pv /tmp/var/backups/testrail/testrail.sql.gz | gunzip | mysql -u $TESTRAIL_DB_USER -p$TESTRAIl_DB_PASS testrail
