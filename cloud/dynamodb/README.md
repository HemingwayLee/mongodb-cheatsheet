# Set it up locally by docker, [ref](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html)

# Feature
* `Managed` NoSQL database service
  * Don't have to worry about patching and upgrading services
* Support both document and key-value data models  
  * In defition, document store is a subset of key-value data store
  * Data types can be `Scalar Types`, `Document Types` (JSON), or `Set Types`
* Highly scalable
* Highly available (3x replication)
* It supports stream API as well

# Table 
![table structure](https://d1.awsstatic.com/product-marketing/DynamoDB/PartitionKey.8dd0530a7f6d66d101f31de30db515564f4cf28a.png)
* `Hash Key` is `Partition Key`. It is mandatory.
* `Range Key` is `Sort Key`. It is optional. It enable rich queries.
  
## Hash Table
![hashtable](https://user-images.githubusercontent.com/8428372/102005952-3c22cb00-3d60-11eb-9924-145c7e2f872f.png)
* Hash key (and range key together) uniquely identifies an item (by default, same hash key will replace the original item)
* It is used for building an unordered hash index

## Partition and replication
![replication](https://user-images.githubusercontent.com/8428372/102005955-3e852500-3d60-11eb-9ef6-82a3e2690135.png)
* The table is partitioned by `Hash Key`

## Range Key
![partition](https://user-images.githubusercontent.com/8428372/102005954-3d53f800-3d60-11eb-9444-d779d610f973.png)
* `WITHIN` unordered hash index, the data is sorted by the range key

# Indexes
## Global secondary index (GSI)

## Local secondary index (LSI)

# Scaling

## How to handle bursts



