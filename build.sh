#!/usr/bin/env bash

echo ""
echo "Installing Hex/Rebar"
echo "--------------------------"
MIX_ENV=prod mix local.hex --if-missing --force
MIX_ENV=prod mix local.rebar --if-missing --force

echo ""
echo "Getting/compiling Hex dependencies"
echo "--------------------------"
MIX_ENV=prod mix deps.get --only prod
MIX_ENV=prod mix deps.compile

echo ""
echo "Getting/compiling NPM dependencies"
echo "--------------------------"
npm install --prefix ./assets
NODE_ENV=production npm run deploy --prefix ./assets
MIX_ENV=prod mix phx.digest

echo ""
echo "Generating release"
echo "--------------------------"
MIX_ENV=prod mix release --overwrite
