#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

aws dynamodb create-table \
  --table-name Students \
  --attribute-definitions \
    AttributeName=MyName,AttributeType=S \
  --key-schema \
    AttributeName=MyName,KeyType=HASH \
  --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --provisioned-throughput \
    ReadCapacityUnits=10,WriteCapacityUnits=5

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2

aws dynamodb put-item --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item '{"MyName": {"S": "James"}, "Age": {"N": "26"}}'

aws dynamodb put-item --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item '{"MyName": {"S": "Kenny"}, "Company": {"S": "TrendMicro"} }'

aws dynamodb put-item --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item '{"MyName": {"S": "Hemingway"}, "Country": {"S": "Japan"} }'


# The hash key must use `equality`
aws dynamodb query --table-name Students \
  --key-condition-expression "MyName = :yyyy" \
  --expression-attribute-values  '{":yyyy":{"S":"Hemingway"}}' \
  --region us-west-2 \
  --endpoint-url http://localhost:8000


# You will get this error if you try to use >=, <, begins_with etc 
#  in the hash-based condition of your key condition expression.

aws dynamodb query --table-name Students \
  --key-condition-expression "begins_with(MyName, :yyyy)" \
  --expression-attribute-values  '{":yyyy":{"S":"H"}}' \
  --region us-west-2 \
  --endpoint-url http://localhost:8000
