#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

echo -e "\033[1;31m Create Table \033[0m"
aws dynamodb create-table \
  --table-name Students \
  --attribute-definitions \
    AttributeName=MyName,AttributeType=S \
    AttributeName=MyAge,AttributeType=N \
    AttributeName=Generation,AttributeType=N \
  --key-schema \
    AttributeName=MyName,KeyType=HASH \
    AttributeName=MyAge,KeyType=RANGE \
  --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --billing-mode PAY_PER_REQUEST \
  --global-secondary-indexes \
    '[
      {
        "IndexName": "AgeIndex",
        "KeySchema": [{
          "AttributeName":"Generation",
          "KeyType":"HASH"
        },{
          "AttributeName":"MyAge",
          "KeyType":"RANGE"
        }],
        "Projection":{
          "ProjectionType":"INCLUDE",
          "NonKeyAttributes":["Title"]
        }
      }
    ]'

echo -e "\033[1;31m List Table \033[0m"
aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2

echo -e "\033[1;31m Insert Duplicated Data \033[0m"
aws dynamodb put-item --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item '{"MyName": {"S": "James"}, "MyAge": {"N": "26"}, "Generation": {"N": "20"}}'

aws dynamodb put-item --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --item '{"MyName": {"S": "Mike"}, "MyAge": {"N": "26"},  "Generation": {"N": "20"}}'

echo -e "\033[1;31m Scan Table \033[0m"
aws dynamodb scan --table-name Students --region us-west-2 \
  --endpoint-url http://localhost:8000

echo -e "\033[1;31m Query Table Index \033[0m"
aws dynamodb query --table-name Students \
  --index-name AgeIndex \
  --key-condition-expression "Generation = :aaa" \
  --expression-attribute-values  '{":aaa":{"N":"20"}}' \
  --region us-west-2 \
  --endpoint-url http://localhost:8000

