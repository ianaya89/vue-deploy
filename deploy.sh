#!/usr/bin/env sh

set -e

npm run build
cd dist

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git add -A
git commit -m 'deploy'

cd -