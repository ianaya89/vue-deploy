#!/bin/bash

set -e

docker build . -t vue-deploy
docker run -d -p 8080:80 vue-deploy
