#!/bin/bash

DOWNLOAD_DIR=/tmp/testrail_install
mkdir -pv ${DOWNLOAD_DIR}
wget https://secure.gurock.com/downloads/testrail/testrail-latest-ion71.zip -P ${DOWNLOAD_DIR}
unzip ${DOWNLOAD_DIR}/testrail-*.zip -d ${DOWNLOAD_DIR}
sudo cp -r ${DOWNLOAD_DIR}/testrail /var/www/html/
rm -rf ${DOWNLOAD_DIR}
