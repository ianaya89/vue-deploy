#!/usr/bin/env sh

set -e

npm run build
cd dist

surge

cd -