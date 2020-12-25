import os
import boto3
from boto3.dynamodb.conditions import Key

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
                'AttributeName': 'username',
                'KeyType': 'HASH'
            },
            {
                'AttributeName': 'last_name',
                'KeyType': 'RANGE'
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'username',
                'AttributeType': 'S'
            },
            {
                'AttributeName': 'last_name',
                'AttributeType': 'S'
            },
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 4000,
            'WriteCapacityUnits': 4000
        },
        GlobalSecondaryIndexes=[
            {
                'IndexName': 'idxLastName',
                'KeySchema': [
                    {
                        'AttributeName': 'last_name',
                        'KeyType': 'HASH'
                    },
                ],
                'Projection': {
                    'ProjectionType': 'INCLUDE',
                    'NonKeyAttributes': [
                        'AAA',
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

def put_item(table):
    response = table.put_item(
        Item={
            'username': 'ywlee',
            'last_name': 'YunWei',
            'AAA': 'BBB'
        }
    )
    print(table.item_count)


def query(table):
    response = table.query(
        IndexName='idxLastName',
        KeyConditionExpression=Key('last_name').eq('YunWei')
    )
        
    items = response['Items']
    for item in items:
        print(item['last_name'], ":", item['AAA'])


if __name__ == '__main__':
    table = create_table()
    put_item(table)
    query(table)
