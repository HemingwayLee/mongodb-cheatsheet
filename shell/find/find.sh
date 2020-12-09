set -e

red='\033[0;31m'
nc='\033[0m'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.remove({});'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert([{"abc":1},{"def":4}]);'
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert({"zzz":2});'
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert({"xyz":3});'
echo -e $red"equal"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.find({"abc":1});'


