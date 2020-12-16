# How to make right queries

## Hash key is very limited
* `Hash key` can not be used for `>`, `<`, `begin_with`
* query can not be made without `Hash key` 

## Key schema design thinking
* Make a table for each kind of search
  * GSI is another table which hash key does not have to be unique

# Ref
https://stackoverflow.com/questions/31830888/dynamodb-query-error-query-key-condition-not-supported  
https://stackoverflow.com/questions/62090021/is-it-possible-to-run-a-greater-than-query-in-aws-dynamodb  
https://stackoverflow.com/questions/52375764/how-to-query-dynamodb-without-using-hashkey  



