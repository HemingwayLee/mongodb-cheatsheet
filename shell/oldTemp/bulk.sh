#Exit immediately if a command exits with a non-zero exit status.
set -e

red='\033[0;31m'
nc='\033[0m'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.remove({});'

mongo 127.0.0.1:27017/mydb --eval 'var bulk = db.mrx.initializeUnorderedBulkOp();
bulk.insert( { item: "abc123", defaultQty: 100, status: "A", points: 100 } );
bulk.insert( { item: "ijk123", defaultQty: 200, status: "A", points: 200 } );
bulk.insert( { item: "mop123", defaultQty: 0, status: "P", points: 0 } );
bulk.execute();'

mongo 127.0.0.1:27017/mydb --eval 'db.mrx.find();'