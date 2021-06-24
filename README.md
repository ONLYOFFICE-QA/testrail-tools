# testrail-restore-backup

## How to tests using Docker

1. Fill empty ENV vars in restore-backup.sh file
2. `rake run`

## How to upgrade php to 7.4 on Ubuntu 18.04

Testrail v7.0 requires php v7.4 which is not available on Ubuntu 18.04 by default

To upgrade use:

```shell
apt -y install software-properties-common
add-apt-repository -y ppa:ondrej/php
apt -y purge php php7.2
apt -y install php7.4 \
               php7.4-curl \
               php7.4-mbstring \
               php7.4-mysql \
               php7.4-xml
apt -y autoremove

wget -P /tmp https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar xvf /tmp/ioncube_loaders_lin_x86-64.tar.gz -C /opt
rm -rf /tmp/ioncube_loaders_lin_x86-64.tar.gz

PHP_MAJOR_VERSION='7'
PHP_MINOR_VERSION='4'
echo "zend_extension=/opt/ioncube/ioncube_loader_lin_${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}.so" >> /etc/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}/apache2/php.ini
echo "zend_extension=/opt/ioncube/ioncube_loader_lin_${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}.so" >> /etc/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}/cli/php.ini

a2dismod php7.2
a2enmod php7.4
service apache2 restart
```
