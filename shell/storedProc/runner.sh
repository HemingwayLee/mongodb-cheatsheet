set -e

red='\033[0;31m'
nc='\033[0m'

echo -e $red"run js script"$nc
mongo 127.0.0.1:27017/mydb < myjs.js


