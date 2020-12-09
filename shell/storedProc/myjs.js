
db.mrx.remove({});
db.mrx.insert([{"abc":1},{"def":4}]);
db.mrx.insert({"zzz":2});

db.mrx.find({"abc":1});

