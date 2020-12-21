import os
import boto3
import datetime
import math
import time
import argparse
from table_creator import TblScan, TblIdxQuery
from data_generator import get_random_dt
from datetime import timezone

ADDRESS = os.getenv('DYNAMODB_ADDRESS', 'localhost:8000')
INSERT_DATA_COUNT = 15

def test_datatime_string():
    localtime = datetime.datetime.now()
    print(localtime)
    utctime = datetime.datetime.now(tz=timezone.utc)
    print(utctime)
    print(utctime.strftime("%Y-%m-%dT%H:%M:%SZ"))
    print(utctime.strftime("%Y-%m-%d"))
    print(utctime.timestamp())
    print(math.floor(utctime.timestamp()))



def main(dynamodb, args):
    if args["mode"] == "create":
        items = get_random_dt("2020-11-01", "2020-12-20", INSERT_DATA_COUNT)
        for tester in [TblIdxQuery(), TblScan()]:
            tester.create(dynamodb)
            for ts in items:
                tester.insert(ts)
            # tester.bulk_insert(items)
    elif args["mode"] == "show":
        for tester in [TblIdxQuery(), TblScan()]:
            tester.setup(dynamodb)
            tester.show_table()
    else:
        tester = TblIdxQuery() if args["mode"] == 'query' else TblScan()
        tester.setup(dynamodb)
        tsTarget = datetime.datetime.strptime('2020-12-01T00:00:00.000000+00:00', '%Y-%m-%dT%H:%M:%S.%f%z').timestamp()
        
        start_time = time.time()
        allData = tester.query(tsTarget)
        elapsed_time = time.time() - start_time
        print(f"count: {len(allData)}")
        print(elapsed_time)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Dynamodb performance tester')
    parser.add_argument('-m','--mode', help='Please put your mode', choices=['show','create','query','scan'], required=True)
    args = vars(parser.parse_args())

    print(f"{ADDRESS}")
    dynamodb = boto3.resource(
        'dynamodb', 
        endpoint_url=f"http://{ADDRESS}",
        region_name='us-west-2')

    main(dynamodb, args)
