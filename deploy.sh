#!/usr/bin/env sh

npm run build
firebase deploy --only hosting
