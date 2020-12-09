# database `mydb` will be created if not exist

#Exit immediately if a command exits with a non-zero exit status.
set -e

red='\033[0;31m'
nc='\033[0m'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.remove({});'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert([{"abc":1},{"def":4}]);'
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert({"zzz":2});'
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.insert({"xyz":3});'

echo -e $red"show all elements"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.find();'

echo -e $red"show count"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.count();'

echo -e $red"show top 3"$nc
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.find().limit(3);'


