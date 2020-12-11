#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

aws dynamodb create-table \
  --table-name Students \
  --attribute-definitions \
    AttributeName=Name,AttributeType=S \
    AttributeName=Age,AttributeType=N \
  --key-schema \
    AttributeName=Name,KeyType=HASH \
  --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --provisioned-throughput \
    ReadCapacityUnits=10,WriteCapacityUnits=5 \
  --global-secondary-indexes \
      '[
          {
              "IndexName": "AgeIndex",
              "KeySchema": [{
                "AttributeName":"Age",
                "KeyType":"HASH"
              }],
              "Projection":{
                "ProjectionType":"INCLUDE",
                "NonKeyAttributes":["Title"]
              },
              "ProvisionedThroughput": {
                "ReadCapacityUnits": 10,
                "WriteCapacityUnits": 5
              }
          }
      ]'

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2

aws dynamodb batch-write-item --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --request-items file://items.json

# See all data
# aws dynamodb scan --table-name Students --region us-west-2 --endpoint-url http://localhost:8000

