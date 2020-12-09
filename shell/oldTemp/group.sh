set -e

red='\033[0;31m'
nc='\033[0m'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.remove({});'

#test
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert([{"gender":1,"age":18,"company":"google"},{"gender":0,"age":24,"company":"google"}]);'
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert([{"gender":0,"age":27,"company":"facebook"},{"gender":1,"age":32,"company":"google"}]);'
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert({"gender":1,"age":29,"company":"facebook"});'
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert({"gender":0,"age":29,"company":"google"});'
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert({"gender":0,"age":33,"company":"intel"});'
echo -e $red"group by and sum"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.aggregate({
  $group: { 
    _id: "$company", 
    total: { $sum: "$age" }
  }});'

echo -e $red"group by and count"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.aggregate({
  $group: { 
    _id: "$company", 
    total: { $sum: 1 }
  }});'

echo -e $red"group by and average"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.aggregate({
  $group: { 
    _id: "$company", 
    total: { $avg: "$age" }
  }});'

#ascending
echo -e $red"group by and order by company name asc"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.aggregate({
  $group: { 
    _id: "$company", 
    total: { $avg: "$age" }
  }},{
  $sort:{
    "_id":1
  }});'

#descending
echo -e $red"group by and order by company name desc"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.aggregate({
  $group: { 
    _id: "$company", 
    total: { $avg: "$age" }
  }},{
  $sort:{
    "_id":-1
  }});'

echo -e $red"group by and order by total"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.aggregate({
  $group: { 
    _id: "$company", 
    total: { $avg: "$age" }
  }},{
  $sort:{
    "total":1
  }});'

echo -e $red"where and group by and order by total"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.aggregate({
  $match: { 
    "gender": 0
  }},{
  $group: { 
    _id: "$company", 
    total: { $avg: "$age" }
  }},{
  $sort:{
    "total":1
  }});'
