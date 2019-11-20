s3_role=$(aws sts assume-role \
                    --role-arn "arn:aws:iam::236586087760:role/demos3stack1-S3AccessRole-1RQB8XHVYIJD8" \
                    --role-session-name "S3UloadSession")

export AWS_ACCESS_KEY_ID=$(echo $s3_role | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $s3_role | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $s3_role | jq -r .Credentials.SessionToken)

if ! aws sts get-caller-identity | grep -q 'S3AccessRole'; then
  echo "No Assumed Role found"
  exit
fi

echo "Right role assigned.Proceeding..."

aws s3 cp awslogo.jpeg s3://sddemos3
aws s3api put-object-tagging --bucket sddemos3 --key "awslogo.jpeg" --tagging 'TagSet=[{Key=org,Value=awstagged}]'

aws s3 cp netflixlogo.jpeg s3://sddemos3
aws s3api put-object-tagging --bucket sddemos3 --key "netflixlogo.jpeg" --tagging 'TagSet=[{Key=org,Value=netflixtagged}]'

