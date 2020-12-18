import os
import boto3

# According to document, `endpoint_url` and `region_name` were not there
# it has to be the argument for resource()
dynamodb = boto3.resource(
    'dynamodb', 
    endpoint_url="http://localhost:8000",
    region_name='us-west-2')

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
    }
)

table.meta.client.get_waiter('table_exists').wait(TableName='users')
print(table.item_count)

response = table.put_item(
    Item={
        'username': 'ywlee',
        'last_name': 'YunWei'
    }
)
print(table.item_count)



