set -e

red='\033[0;31m'
nc='\033[0m'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.remove({});'

./csv2json.sh data.csv > data.json

printf 'db.mrx.insert(' > data.js
cat data.json >> data.js
echo ');' >> data.js

mongo 127.0.0.1:27017/mydb data.js
mongo 127.0.0.1:27017/mydb --eval 'db.mrx.find();'

