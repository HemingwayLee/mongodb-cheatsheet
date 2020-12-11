# Sample code explanation

```
#!/bin/bash

export AWS_ACCESS_KEY_ID='DUMMYIDEXAMPLE'
export AWS_SECRET_ACCESS_KEY='DUMMYEXAMPLEKEY'

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-west-2
```

* `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` can be anything, and they must be set
* `--endpoint-url` and `--region` must be in the command

# Note
* dynamodb is schemaless (except key schema)
* The number of `--attribute-definitions` and the number of `--key-schema` must match
* By default, it will replace an existing item if you insert the same primary key


