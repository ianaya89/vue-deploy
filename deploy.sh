#!/bin/bash

set -e

npm run build

S3_BUCKET=aws.vuedeploy.com
CLOUDFRONT_DISTRIBUTION=E3TIGM2PLD4QZ

echo "🗄 Uploading files to bucket: ${S3_BUCKET}"
aws s3 cp \
  --recursive \
  --acl public-read \
  --region us-east-1 \
  ./dist/ s3://"${S3_BUCKET}"

echo "🗑 Invalidate cloud front distribution cache: ${CLOUDFRONT_DISTRIBUTION}"
aws configure set preview.cloudfront true
aws cloudfront create-invalidation --distribution-id "${CLOUDFRONT_DISTRIBUTION}" --paths "/*"
