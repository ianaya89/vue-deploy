#!/bin/bash

set -e

npm run build
netlify deploy --dir dist --prod