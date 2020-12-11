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
  * Allowed values for `--key-schema`: `HASH | RANGE`
* By default, it will replace an existing item if you insert the same primary key
  * `--condition-expression "attribute_not_exists(XXXX)"` need to be there
* get-item will be slight fast than query, [ref](https://stackoverflow.com/questions/12241235/dynamodb-query-versus-getitem-for-single-item-retrieval-based-on-the-index)


