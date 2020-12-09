set -e

red='\033[0;31m'
nc='\033[0m'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.remove({});'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert({"employee":[
    {"name":"kenny"},
    {"name":"james"},
    {"name":"chris"},
    {"name":"ywlee"}
  ]});'
# we can not insert multiple document by using $addToSet
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.update(
  {},
  {$addToSet:{"employee":{"name":"kristof"}/*, {"name":"mark"}*/}});'

# this is add another array into it, not what we want
# mongo 127.0.0.1:27017/mydb --eval 'db.mrx.update(
#   {},
#   {$addToSet:{"employee":[{"name":"rose"}, {"name":"mark"}]}});'

#we need $each
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.update(
  {},
  {$addToSet:{"employee":{$each:[{"name":"rose"}, {"name":"mark"}]}}}
);'


echo -e $red"show all"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.find();'

#it will return entire array
echo -e $red"element match"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.find(
  {employee:{$elemMatch:{name:"james"}}}
);'

#it will return entire array
echo -e $red"find"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.find(
  {"employee.name":"james"}
);'


echo -e $red"get count in array"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.aggregate(
  {$project:{total:{$size:"$employee"}}}
);'
