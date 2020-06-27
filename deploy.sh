#!/usr/bin/env sh

set -e

npm run build
cd dist

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git add -A
git commit -m 'deploy'

git push -f git@github.com:ianaya89/vue-deploy.git master:gh-pages

cd -