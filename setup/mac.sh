#! /bin/bash
set -euo pipefail

# Install postgresql
if command -v createdb &> /dev/null; then
  echo "Posgres already installed, skipping install..."
else
  brew install postgresql
  brew services start postgresql
  createdb cogrammers-aws-dev
fi

echo "Installing npm packages"
npm install
npm install --save sequelize-cli
npm install --save pg@6 pg-hstore

echo "Setting up config file"
export REPLACEMENT="\"username\": \"$USER\","
sed -i.bak 's/"username".*/'"$REPLACEMENT"'/g' server/config.json
rm server/config.json.bak

echo "Migrating the database"
./node_modules/.bin/sequelize db:migrate
