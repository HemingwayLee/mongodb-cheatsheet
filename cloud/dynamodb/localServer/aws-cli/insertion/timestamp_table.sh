#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

aws dynamodb create-table \
  --table-name MyTbl \
  --attribute-definitions \
    AttributeName=MyDate,AttributeType=N \
    AttributeName=MyFile,AttributeType=S \
  --key-schema \
    AttributeName=MyDate,KeyType=HASH \
    AttributeName=MyFile,KeyType=RANGE \
  --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --provisioned-throughput \
    ReadCapacityUnits=10,WriteCapacityUnits=5

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2

NOW=`date +%s`
ITEM='{"MyDate": {"N": "'${NOW}'"}, "MyFile": {"S": "aaa.txt"}}'
# echo $ITEM
aws dynamodb put-item --table-name MyTbl --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item "${ITEM}"

NOW=`date +%s`
ITEM='{"MyDate": {"N": "'${NOW}'"}, "MyFile": {"S": "bbb.txt"}}'
# echo $ITEM
aws dynamodb put-item --table-name MyTbl --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item "${ITEM}"

aws dynamodb scan --table-name MyTbl --region us-west-2 \
  --endpoint-url http://localhost:8000
