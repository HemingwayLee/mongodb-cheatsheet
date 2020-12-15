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
    ReadCapacityUnits=300,WriteCapacityUnits=100

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2


ARRAY=()
CHARS=abcd1234ABCD
END=30
for i in $(seq 1 $END); 
do 
  # NOW=`date +%s`
  NOW=`shuf -i 1607900000-1607992197 -n 1`
  FILE=`echo -n "${CHARS:RANDOM%${#CHARS}:2}.txt"`

  ITEM='{"MyDate": {"N": "'${NOW}'"}, "MyFile": {"S": "'${FILE}'"}}'
  ARRAY+=("$ITEM")
done


echo "Insert started"
STARTTIME=`date +%s`
for i in "${ARRAY[@]}"
do
  aws dynamodb put-item --table-name MyTbl --region us-west-2 \
    --endpoint-url http://localhost:8000 \
    --item "$i"
done
echo "Insert finished"
ENDTIME=`date +%s`
echo "It takes $((${ENDTIME} - ${STARTTIME}))"




# Too many items to see
# aws dynamodb scan --table-name MyTbl --region us-west-2 \
#   --endpoint-url http://localhost:8000
