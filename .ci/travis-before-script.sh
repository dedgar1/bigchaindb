#!/bin/bash

set -e -x

if [[ "${TOXENV}" == *-rdb ]]; then
    rethinkdb --daemon
elif [[ "${BIGCHAINDB_DATABASE_BACKEND}" == mongodb ]]; then
    wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-3.4.1.tgz -O /tmp/mongodb.tgz
    tar -xvf /tmp/mongodb.tgz
    mkdir /tmp/mongodb-data
    ${PWD}/mongodb-linux-x86_64-3.4.1/bin/mongod --dbpath=/tmp/mongodb-data --replSet=rs0 &> /dev/null &
fi
