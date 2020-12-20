import datetime
import math
from datetime import timezone, timedelta, date
from boto3.dynamodb.conditions import Key, Attr

def daterange(start_date, end_date):
    for n in range(int((end_date - start_date).days)):
        yield start_date + timedelta(n)

class TblIdxQuery: 
    _table_name = 'TblIdxQuery'
    _table = None
    _db = None
    def create(self, dynamodb): 
        self._db = dynamodb
        self._table = dynamodb.create_table(
            TableName=self._table_name,
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

        self._table.meta.client.get_waiter('table_exists').wait(TableName=self._table_name)
        # print(self._table.item_count)

    def insert(self, ts):
        if not self._table:
            return

        yyyyMMdd = datetime.datetime.utcfromtimestamp(ts).strftime("%Y-%m-%d")
        response = self._table.put_item(
            Item={
                'filename': 'AAA.txt',
                'process_complete_date': ts,
                'process_complete_year_month_day': yyyyMMdd,
                'AAA': 12,
                'BBB': 32,
                'CCC': 12,
            }
        )
        # print(response)


    def query(self, tsStart):
        if not self._table:
            return

        today = date.today()
        startDate = datetime.datetime.fromtimestamp(tsStart, timezone.utc).date()
        
        allData = []
        for idx, single_date in enumerate(daterange(startDate, today)):
            print(f"query times {idx}")
            yyyyMMdd = single_date.strftime("%Y-%m-%d")
            
            if idx == 0:
                response = self._table.query(
                    IndexName='idxDate',
                    KeyConditionExpression=Key('process_complete_year_month_day').eq(yyyyMMdd)
                )
            else:
                response = self._table.query(
                    IndexName='idxDate',
                    KeyConditionExpression=Key('process_complete_year_month_day').eq(yyyyMMdd) & Key("process_complete_date").gte(math.floor(tsStart))
                )
                
            items = response['Items']
            allData.extend(items)

        return allData

    

class TblScan: 
    _table_name = 'TblScan'
    _table = None
    _db = None
    def create(self, dynamodb): 
        self._db = dynamodb
        self._table = dynamodb.create_table(
            TableName=self._table_name,
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
                }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 4000,
                'WriteCapacityUnits': 4000
            }
        )

        self._table.meta.client.get_waiter('table_exists').wait(TableName=self._table_name)
        # print(self._table.item_count)

    def insert(self, ts):
        if not self._table:
            return

        yyyyMMdd = datetime.datetime.utcfromtimestamp(ts).strftime("%Y-%m-%d")
        response = self._table.put_item(
            Item={
                'filename': 'AAA.txt',
                'process_complete_date': ts,
                'process_complete_year_month_day': yyyyMMdd,
                'AAA': 12,
                'BBB': 32,
                'CCC': 12,
            }
        )
        # print(response)

    # def bulk_insert(self, items):
    #     if not self._table or not self._db:
    #         return

    #     data = { self._table_name: [] }
    #     for ts in items:
    #         yyyyMMdd = datetime.datetime.utcfromtimestamp(ts).strftime("%Y-%m-%d")
    #         data[self._table_name].append({
    #             "PutRequest": {
    #                 "Item": {
    #                     "filename": {
    #                         "S": "AAA.txt"
    #                     },
    #                     "process_complete_date": {
    #                         "N": f"{ts}"
    #                     },
    #                     "process_complete_year_month_day": {
    #                         "S": yyyyMMdd
    #                     },
    #                     "AAA": {
    #                         "N": "312"
    #                     },
    #                     "BBB": {
    #                         "N": "321"
    #                     },
    #                     "CCC": {
    #                         "N": "231"
    #                     }
    #                 }
    #             }
    #         })

    #     self._db.batch_write_item(RequestItems=data)
    #     print(f"{self._table.item_count} items in the table")

    def query(self, tsStart):
        if not self._table:
            return
        
        response = self._table.scan(
            FilterExpression=Attr("process_complete_date").gte(math.floor(tsStart))
        )

        return response['Items']

