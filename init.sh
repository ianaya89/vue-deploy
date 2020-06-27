#!/bin/bash

set -e

export CERTIFICATE_ARN="arn:aws:acm:us-east-1:983755687467:certificate/3a5daad5-8aae-4dcf-ae24-b0390029ef6f"

# S3
getBucketConfig () {
  export BUCKET_NAME=$1
  export BUCKET_URL="$BUCKET_NAME.s3-website-us-east-1.amazonaws.com"
  export BUCKET_POLICY="{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
      {
        \"Sid\": \"PublicReadGetObject\",
        \"Effect\": \"Allow\",
        \"Principal\": \"*\",
        \"Action\": \"s3:GetObject\",
        \"Resource\": \"arn:aws:s3:::$BUCKET_NAME/*\"
      }
    ]
  }"
}

# CloudFront
getCdnConfig () {
  export CDN_ORIGIN_ID="s3-$BUCKET_NAME"
  export CDN_CONFIG="{
     \"Tags\": {
        \"Items\": []
    },
    \"DistributionConfig\": {
      \"CallerReference\": \"$BUCKET_NAME\",
      \"Aliases\": {
        \"Quantity\": 1,
        \"Items\": [\"$BUCKET_NAME\"]
      },
      \"Origins\": {
        \"Quantity\": 1,
        \"Items\": [
          {
            \"Id\": \"$CDN_ORIGIN_ID\",
            \"DomainName\": \"$BUCKET_URL\",
            \"OriginPath\": \"\",
            \"CustomHeaders\": {
              \"Quantity\": 0
            },
            \"CustomOriginConfig\": {
              \"HTTPPort\": 80,
              \"HTTPSPort\": 443,
              \"OriginProtocolPolicy\": \"http-only\"
            }
          }
        ]
      },
      \"OriginGroups\": {
        \"Quantity\": 0
      },
      \"DefaultCacheBehavior\": {
        \"TargetOriginId\": \"$CDN_ORIGIN_ID\",
        \"ForwardedValues\": {
          \"QueryString\": false,
          \"Cookies\": {
            \"Forward\": \"none\"
          },
          \"Headers\": {
            \"Quantity\": 0
          },
          \"QueryStringCacheKeys\": {
            \"Quantity\": 0
          }
        },
        \"TrustedSigners\": {
          \"Enabled\": false,
          \"Quantity\": 0
        },
        \"ViewerProtocolPolicy\": \"redirect-to-https\",
        \"MinTTL\": 0,
        \"AllowedMethods\": {
          \"Quantity\": 3,
          \"Items\": [
            \"HEAD\",
            \"GET\",
            \"OPTIONS\"
          ],
          \"CachedMethods\": {
            \"Quantity\": 2,
            \"Items\": [
              \"HEAD\",
              \"GET\"
            ]
          }
        },
        \"SmoothStreaming\": false,
        \"DefaultTTL\": 86400,
        \"MaxTTL\": 31536000,
        \"Compress\": true,
        \"LambdaFunctionAssociations\": {
          \"Quantity\": 0
        },
        \"FieldLevelEncryptionId\": \"\"
      },
      \"CacheBehaviors\": {
        \"Quantity\": 0
      },
      \"CustomErrorResponses\": {
        \"Quantity\": 0
      },
      \"Comment\": \"\",
      \"Logging\": {
        \"Enabled\": false,
        \"IncludeCookies\": false,
        \"Bucket\": \"\",
        \"Prefix\": \"\"
      },
      \"PriceClass\": \"PriceClass_All\",
      \"Enabled\": true,
      \"ViewerCertificate\": {
        \"CloudFrontDefaultCertificate\": false,
        \"ACMCertificateArn\": \"$CERTIFICATE_ARN\",
        \"CertificateSource\": \"acm\",
        \"SSLSupportMethod\": \"sni-only\"
      },
      \"Restrictions\": {
        \"GeoRestriction\": {
          \"RestrictionType\": \"none\",
          \"Quantity\": 0
        }
      },
      \"WebACLId\": \"\",
      \"HttpVersion\": \"http2\",
      \"IsIPV6Enabled\": true
    }
  }"
}

init () {
  echo "🥃 Creating new S3 + CloudFront setup"

  getBucketConfig "$1"
  printf "\n📦 S3 Bucket config:\n"
  echo "👉 Name: $BUCKET_NAME"
  echo "👉 URL: $BUCKET_URL"
  echo "👉 Policy Resource: $(echo "$BUCKET_POLICY" | jq .Statement[0]."Resource" --raw-output)"

  getCdnConfig
  printf "\n📦 CloudFront Distribution config:\n"
  echo "👉 ID: $CDN_ORIGIN_ID"
  echo "👉 Reference: $(echo "$CDN_CONFIG" | jq .DistributionConfig.CallerReference --raw-output)"
  echo "👉 Origin: $(echo "$CDN_CONFIG" | jq .DistributionConfig.Origins.Items[0]."Id" --raw-output)"
  echo "👉 Domain: $(echo "$CDN_CONFIG" | jq .DistributionConfig.Origins.Items[0]."DomainName" --raw-output)"
  echo "👉 Certificate: $(echo "$CDN_CONFIG" | jq .DistributionConfig.ViewerCertificate."ACMCertificateArn" --raw-output)"
  printf "\n"
}

createBucket() {
  printf "\n🤖 Creating the new S3 website bucket: %s" "$BUCKET_NAME"
  aws s3api create-bucket --bucket "$BUCKET_NAME" --region us-east-1
  aws s3 website s3://"$BUCKET_NAME"/ --index-document index.html --error-document index.html
  aws s3api put-bucket-policy --bucket "$BUCKET_NAME" --policy "$BUCKET_POLICY"
  echo "✅ Created the S3 website bucket."
}

createDistribution() {
  printf "\n🤖 Creating the new CloudFront distribution: %s" "$CDN_ORIGIN_ID"
  export CDN_URL
  CDN_URL=$(aws cloudfront create-distribution-with-tags --distribution-config-with-tags "$CDN_CONFIG" | jq .Distribution."DomainName" --raw-output)
  printf "✅ Created the CloudFront distribution: %s" "$CDN_URL"
}

run () {
  if [ -z "$1" ]; then
    echo "❌ Missing required domain name"
    exit 0
  fi

  init "$1"
  read -r -p "Do you want to continue seting up the new environment? [y/N] " response
  if [[ "$response" =~ ^(yes|y)$ ]]; then
    createBucket
    createDistribution
    printf "\n🚀 New environment created successfully: %s" "$BUCKET_NAME"
  else
    echo "❌ Aborting environment creation..."
    exit 0
  fi
}

run "$1"
