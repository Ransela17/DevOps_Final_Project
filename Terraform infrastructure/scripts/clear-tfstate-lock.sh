#!/bin/bash
set -xe
DB_TABLE=tf-workshop-site-locks
BASE_KEY=migo-terraform/workshop-site-state/terraform.tfstate
aws dynamodb delete-item --table-name $DB_TABLE --key "{\"LockID\":{\"S\":\"${BASE_KEY}\"}}" | jq || exit 1
aws dynamodb delete-item --table-name $DB_TABLE --key "{\"LockID\":{\"S\":\"${BASE_KEY}-md5\"}}" | jq || exit 1

