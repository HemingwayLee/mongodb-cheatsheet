#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

aws dynamodb create-table \
  --table-name MyTbl \
  --attribute-definitions \
    AttributeName=MyFile,AttributeType=S \
    AttributeName=MyDate,AttributeType=N \
  --key-schema \
    AttributeName=MyFile,KeyType=HASH \
    AttributeName=MyDate,KeyType=RANGE \
  --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --provisioned-throughput \
    ReadCapacityUnits=4000,WriteCapacityUnits=4000

aws dynamodb create-table \
  --table-name MyTblWithIdx \
  --attribute-definitions \
    AttributeName=MyFile,AttributeType=S \
    AttributeName=MyDate,AttributeType=N \
    AttributeName=YearMonthDay,AttributeType=S \
  --key-schema \
    AttributeName=MyFile,KeyType=HASH \
    AttributeName=MyDate,KeyType=RANGE \
  --region us-west-2 \
  --endpoint-url http://localhost:8000 \
  --provisioned-throughput \
    ReadCapacityUnits=4000,WriteCapacityUnits=4000 \
  --global-secondary-indexes \
    '[
      {
        "IndexName": "MyDateIndex",
        "KeySchema": [{
          "AttributeName":"YearMonthDay",
          "KeyType":"HASH"
        }, {
          "AttributeName":"MyDate",
          "KeyType":"RANGE"
        }],
        "Projection":{
          "ProjectionType":"INCLUDE",
          "NonKeyAttributes":["A", "B", "C"]
        },
        "ProvisionedThroughput": {
          "ReadCapacityUnits": 4000,
          "WriteCapacityUnits": 4000
        }
      }
    ]'

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2


echo "Data preparation started"
ARRAY=()
CHARS=abcd1234ABCD
END=500
for i in $(seq 1 $END); 
do 
  # NOW=`date +%s`
  NOW=`shuf -i 1607900000-1607992197 -n 1`
  DAY=$(($NOW/1000*1000))
  FILE=`echo -n "${CHARS:RANDOM%${#CHARS}:2}.txt"`

  ITEM='{"MyDate": {"N": "'${NOW}'"}, "MyFile": {"S": "'${FILE}'"}, "YearMonthDay": {"S": "'${DAY}'"}, "A": {"S": "AAA"}, "B": {"S": "BBB"}, "C": {"S": "CCC"}}'
  ARRAY+=("$ITEM")
done
echo "Data preparation finished"


echo "Insert TBL started"
STARTTIME=`date +%s`
for i in "${ARRAY[@]}"
do
  aws dynamodb put-item --table-name MyTbl --region us-west-2 \
    --endpoint-url http://localhost:8000 \
    --item "$i"
done
echo "Insert TBL finished"
ENDTIME=`date +%s`
echo "It takes $((${ENDTIME} - ${STARTTIME}))"


echo "Insert TBL with IDX started"
STARTTIME=`date +%s`
for i in "${ARRAY[@]}"
do
  aws dynamodb put-item --table-name MyTblWithIdx --region us-west-2 \
    --endpoint-url http://localhost:8000 \
    --item "$i"
done
echo "Insert TBL with IDX finished"
ENDTIME=`date +%s`
echo "It takes $((${ENDTIME} - ${STARTTIME}))"



