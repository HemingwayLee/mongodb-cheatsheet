# How to run
```
docker-compose up
```

## Install `aws-cli`
```
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

* [Ref](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-install-cmd)

## Connect to local `dynamodb` from another tab
```
$ aws dynamodb list-tables --endpoint-url http://localhost:8000 --region local
{
    "TableNames": []
}
```

or 

```
$ aws dynamodb describe-limits --endpoint-url http://localhost:8000 --region us-west-2
{
    "AccountMaxReadCapacityUnits": 80000,
    "AccountMaxWriteCapacityUnits": 80000,
    "TableMaxReadCapacityUnits": 40000,
    "TableMaxWriteCapacityUnits": 40000
}
```
