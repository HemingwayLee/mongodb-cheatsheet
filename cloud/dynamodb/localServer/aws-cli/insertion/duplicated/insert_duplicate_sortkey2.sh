#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

aws dynamodb create-table \
  --table-name Students \
  --attribute-definitions \
    AttributeName=MyName,AttributeType=S \
    AttributeName=MyAge,AttributeType=N \
  --key-schema \
    AttributeName=MyName,KeyType=HASH \
    AttributeName=MyAge,KeyType=RANGE \
  --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --provisioned-throughput \
    ReadCapacityUnits=10,WriteCapacityUnits=5

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2

aws dynamodb put-item --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item '{"MyName": {"S": "James"}, "MyAge": {"N": "26"}, "Location": {"S": "Japan"}}'

aws dynamodb put-item --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item '{"MyName": {"S": "James"}, "MyAge": {"N": "26"}, "Title": {"S": "Developer"} }'

aws dynamodb scan --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000


