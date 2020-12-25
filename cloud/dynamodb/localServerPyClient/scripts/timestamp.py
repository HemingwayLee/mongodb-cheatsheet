import os
import boto3
import datetime
import math
import time
from random import randint
from boto3.dynamodb.conditions import Key
from datetime import timezone, timedelta, date

ADDRESS = os.getenv('DYNAMODB_ADDRESS', 'localhost:8000')
print(f"{ADDRESS}")

dynamodb = boto3.resource(
    'dynamodb', 
    endpoint_url=f"http://{ADDRESS}",
    region_name='us-west-2')

def create_table():
    table = dynamodb.create_table(
        TableName='users',
        KeySchema=[
            {
                'AttributeName': 'filename',
                'KeyType': 'HASH'
            },
            {
                'AttributeName': 'process_complete_date',
                'KeyType': 'RANGE'
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'filename',
                'AttributeType': 'S'
            },
            {
                'AttributeName': 'process_complete_date',
                'AttributeType': 'N'
            },
            {
                'AttributeName': 'process_complete_year_month_day',
                'AttributeType': 'S'   
            }
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 4000,
            'WriteCapacityUnits': 4000
        },
        GlobalSecondaryIndexes=[
            {
                'IndexName': 'idxDate',
                'KeySchema': [
                    {
                        'AttributeName': 'process_complete_year_month_day',
                        'KeyType': 'HASH'
                    },
                    {
                        'AttributeName': 'process_complete_date',
                        'KeyType': 'RANGE'
                    },
                ],
                'Projection': {
                    'ProjectionType': 'INCLUDE',
                    'NonKeyAttributes': [
                        'AAA', 'BBB', 'CCC'
                    ]
                },
                'ProvisionedThroughput': {
                    'ReadCapacityUnits': 4000,
                    'WriteCapacityUnits': 4000
                }
            },
        ]
    )

    table.meta.client.get_waiter('table_exists').wait(TableName='users')
    print(table.item_count)
    return table

def put_item(table, ts):
    # secondTimestamp = math.floor(utctime.timestamp())
    # yyyyMMdd = utctime.strftime("%Y-%m-%d")

    yyyyMMdd = datetime.datetime.utcfromtimestamp(ts).strftime("%Y-%m-%d")
    print(yyyyMMdd)

    table.put_item(
        Item={
            'filename': 'AAA.txt',
            'process_complete_date': ts,
            'process_complete_year_month_day': yyyyMMdd,
            'AAA': 12,
            'BBB': 32,
            'CCC': 12,
        }
    )
    print(table.item_count)


def query_great_than(table, tsStart):
    today = date.today()
    startDate = datetime.datetime.fromtimestamp(tsStart, timezone.utc).date()
    
    allData = []
    for single_date in daterange(startDate, today):
        yyyyMMdd = single_date.strftime("%Y-%m-%d")

        response = table.query(
            IndexName='idxDate',
            KeyConditionExpression=Key('process_complete_year_month_day').eq(yyyyMMdd)
        )
            
        items = response['Items']
        allData.extend(items)

    return allData

def daterange(start_date, end_date):
    for n in range(int((end_date - start_date).days)):
        yield start_date + timedelta(n)


def test_datatime_string():
    localtime = datetime.datetime.now()
    print(localtime)
    utctime = datetime.datetime.now(tz=timezone.utc)
    print(utctime)
    print(utctime.strftime("%Y-%m-%dT%H:%M:%SZ"))
    print(utctime.strftime("%Y-%m-%d"))
    print(utctime.timestamp())
    print(math.floor(utctime.timestamp()))


def get_random_dt(start, end):
    sdt = datetime.datetime.strptime(start, "%Y-%m-%d").timestamp()
    edt = datetime.datetime.strptime(end, "%Y-%m-%d").timestamp()

    count = 30
    data = [randint(sdt, edt) for i in range(0, count)]
    return data


if __name__ == '__main__':
    table = create_table()
    
    data = get_random_dt("2020-11-01", "2020-12-31")
    for ts in data:
        put_item(table, ts)
    
    tsTarget = datetime.datetime.strptime("2020-12-01", "%Y-%m-%d").timestamp()
    allData = query_great_than(table, tsTarget)
    print(allData)

