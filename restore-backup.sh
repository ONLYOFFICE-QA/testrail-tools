AWS_ACCESS_KEY_ID=''
AWS_SECRET_ACCESS_KEY=''
BACKUP_NAME=''

PHP_MAJOR_VERSION='7'
PHP_MINOR_VERSION='2'

sudo apt-get -y update
sudo apt-get -y install curl \
                        mysql-server \
                        php \
                        php-curl \
                        php-mbstring \
                        php-mysql \
                        php-xml \
                        unzip \
                        wget

# Install ioncube loader
wget -P /tmp https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar xvf /tmp/ioncube_loaders_lin_x86-64.tar.gz -C /opt
rm -rf /tmp/ioncube_loaders_lin_x86-64.tar.gz
echo "zend_extension=/opt/ioncube/ioncube_loader_lin_${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}.so" > /etc/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}/apache2/php.ini

# Install aws cli
wget -P /tmp "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
cd /tmp
unzip awscli-exe-linux-x86_64.zip
sudo ./aws/install
rm -rf /tmp/awscli-exe-linux-x86_64.zip
rm -rf /tmp/aws
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws s3 cp s3://nct-testrail-backup/$BACKUP_NAME /tmp

# Unpack backup
tar xvf $BACKUP_NAME
mv /tmp/var/backups/testrail/ /var/www/html
