#!/usr/bin/env bash

echo "Build starting!"
echo "--------------------------"
ssh -T akedia@inhji.de << EOSSH
cd /opt/akedia
git pull
./build.sh
EOSSH
echo "Build complete, restarting..."
ssh -T akedia@inhji.de sudo systemctl restart akedia
