#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'


# aws dynamodb scan --table-name MyTblWithIdx --region us-west-2 \
#   --endpoint-url http://localhost:8000 \
#   --max-items 1


echo "query with IDX started"
STARTTIME=`date +%s`
EXPRESSION='{":ymd":{"S":"1607901000"},":md":{"N":"1607901719"}}'

aws dynamodb query --table-name MyTblWithIdx \
  --index-name MyDateIndex \
  --key-condition-expression "YearMonthDay = :ymd and MyDate >= :md" \
  --expression-attribute-values "${EXPRESSION}" \
  --region us-west-2 \
  --endpoint-url http://localhost:8000
echo "query TBL with IDX finished"
ENDTIME=`date +%s`
echo "It takes $((${ENDTIME} - ${STARTTIME}))"


scan with filter without index 
echo "Scan with filter started"
STARTTIME=`date +%s`
EXPRESSION='{":md":{"N":"1607901719"}}'
aws dynamodb scan --table-name MyTbl --filter-expression "MyDate >= :md" \
  --expression-attribute-values "${EXPRESSION}" \
  --region us-west-2 \
  --endpoint-url http://localhost:8000
echo "Scan with filter finished"
ENDTIME=`date +%s`
echo "It takes $((${ENDTIME} - ${STARTTIME}))"
