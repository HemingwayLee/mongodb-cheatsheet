#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

# It must have a RANGE key in table
# It must have a RANGE key in index as well
aws dynamodb create-table \
  --table-name Students \
  --attribute-definitions \
    AttributeName=MyName,AttributeType=S \
    AttributeName=Age,AttributeType=N \
    AttributeName=Title,AttributeType=S \
  --key-schema \
    AttributeName=MyName,KeyType=HASH \
    AttributeName=Age,KeyType=RANGE \
  --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --provisioned-throughput \
    ReadCapacityUnits=10,WriteCapacityUnits=5 \
  --local-secondary-indexes \
      '[
          {
              "IndexName": "TitleIndex",
              "KeySchema": [{
                "AttributeName":"MyName",
                "KeyType":"HASH"
              }, {
                "AttributeName":"Title",
                "KeyType":"RANGE"
              }],
              "Projection":{
                "ProjectionType":"INCLUDE",
                "NonKeyAttributes":["Location"]
              }
          }
      ]'

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2

aws dynamodb batch-write-item --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --request-items file://items.json

# See all data
# aws dynamodb scan --table-name Students --region us-west-2 --endpoint-url http://localhost:8000

# primary key need to be specified, not very useful
aws dynamodb query --table-name Students \
  --index-name TitleIndex \
  --key-condition-expression "Title = :ttt and MyName = :mn" \
  --expression-attribute-values  '{":ttt":{"S":"Student"},":mn":{"S":"Chris"}}' \
  --region us-west-2 \
  --endpoint-url http://localhost:8000

# You can not search by sort key only, primary key need to be specified
aws dynamodb query --table-name Students \
  --index-name TitleIndex \
  --key-condition-expression "Title = :ttt" \
  --expression-attribute-values  '{":ttt":{"S":"Techlead"}}' \
  --region us-west-2 \
  --endpoint-url http://localhost:8000

