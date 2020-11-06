#!/usr/bin/env bash

echo ""
echo "Build starting!"
echo "--------------------------"
ssh -T akedia@inhji.de << EOSSH
cd /opt/akedia
git pull
./build.sh
EOSSH
echo ""
echo "Build complete, restarting..."
echo "--------------------------"
ssh -T akedia@inhji.de sudo systemctl restart akedia
