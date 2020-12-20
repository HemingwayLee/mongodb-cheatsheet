import os
import boto3
import datetime
import math
import argparse
from table_creator import TblScan, TblIdxQuery
from data_generator import get_random_dt
from datetime import timezone

ADDRESS = os.getenv('DYNAMODB_ADDRESS', 'localhost')
PORT = os.getenv('DYNAMODB_PORT', 8000)
INSERT_DATA_COUNT = 35

def test_datatime_string():
    localtime = datetime.datetime.now()
    print(localtime)
    utctime = datetime.datetime.now(tz=timezone.utc)
    print(utctime)
    print(utctime.strftime("%Y-%m-%dT%H:%M:%SZ"))
    print(utctime.strftime("%Y-%m-%d"))
    print(utctime.timestamp())
    print(math.floor(utctime.timestamp()))

def main(tester):
    print(f"{ADDRESS}:{PORT}")
    dynamodb = boto3.resource(
        'dynamodb', 
        endpoint_url=f"http://{ADDRESS}:{PORT}",
        region_name='us-west-2')

    tester.create(dynamodb)

    data = get_random_dt("2020-11-01", "2020-12-31", INSERT_DATA_COUNT)
    for ts in data:
        tester.insert(ts)

    tsTarget = datetime.datetime.strptime("2020-12-01", "%Y-%m-%d").timestamp()
    allData = tester.query(tsTarget)
    print(allData)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Dynamodb performance tester')
    parser.add_argument('-m','--mode', help='Please put your mode', choices=['query','scan'], required=True)
    args = vars(parser.parse_args())

    tester = TblIdxQuery() if args["mode"] == 'query' else TblScan()
    main(tester)



    
    
    
    

