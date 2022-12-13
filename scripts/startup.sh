#!/bin/bash

service mariadb start

if [ ! -f /.configured ]
then
    mysql -e "create database  NConf;"
    mysql -e "GRANT ALL ON *.* TO nconf@'%' IDENTIFIED BY 'link2db' WITH GRANT OPTION;"
    mysql -e "FLUSH PRIVILEGES;" 
    mysql NConf < /var/www/html/nconf/INSTALL_/create_database.sql
    touch /.configured
fi

#echo "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON nconf.* \
#TO 'root'@'localhost' IDENTIFIED BY 'Nag123'"|mysql;
#s3cmd -c /.s3cfg  get   "s3://example-appops-nconf/${stack}/${colo}/nconf_dump.sql"
#mysql -u root -pNag123 nconf < nconf_dump.sql

#killall mysqld
#sleep 10s

#/usr/bin/mysqld_safe

