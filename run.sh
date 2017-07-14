#!/bin/bash

set -m
set -e

LOG="/var/log/mysql/error.log"

StartMySQL ()
{
    /usr/bin/mysqld_safe ${EXTRA_OPTS} > /dev/null 2>&1 &
    # Time out in 1 minute
    LOOP_LIMIT=60
    for (( i=0 ; ; i++ )); do
        if [ ${i} -eq ${LOOP_LIMIT} ]; then
            echo "Time out. Error log is shown as below:"
            tail -n 100 ${LOG}
            exit 1
        fi
        echo "=> Waiting for confirmation of MySQL service startup, trying ${i}/${LOOP_LIMIT} ..."
        sleep 1
        mysql -uroot -e "status" > /dev/null 2>&1 && break
    done
}

CreateMySQLUser()
{
    echo "=> Creating MySQL user ${MYSQL_USER} with ${_word} password"

    mysql -uroot -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$MYSQL_PASS'"
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"
    echo "=> Done!"
    echo "========================================================================"
    echo "You can now connect to this MySQL Server using:"
    echo ""
    echo "    mysql username developer and password:developer@@!!"
    echo ""
    echo "MySQL user 'root' has no password but only allows local connections"
    echo "========================================================================"
}



echo "=> Starting MySQL ..."
StartMySQL
tail -F $LOG &

# Create admin user and pre create database
    echo "=> Creating db user ..."
    CreateMySQLUser


fg
