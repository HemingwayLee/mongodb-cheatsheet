#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2


