#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

aws dynamodb create-table \
  --table-name Students \
  --attribute-definitions \
    AttributeName=Name,AttributeType=S \
  --key-schema \
    AttributeName=Name,KeyType=HASH \
  --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --provisioned-throughput \
    ReadCapacityUnits=10,WriteCapacityUnits=5

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2

aws dynamodb put-item --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item '{"Name": {"S": "James"}, "Age": {"N": "26"}, "Point": {"N": "2.43"}}'

aws dynamodb put-item --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item '{"Name": {"S": "Kenny"}, "Company": {"S": "TrendMicro"}, "IsMe": {"BOOL": true} }'

aws dynamodb scan --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000


