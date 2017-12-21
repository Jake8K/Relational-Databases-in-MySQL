var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'mysql.eecs.oregonstate.edu',
  user            : 'cs340_karczj',
  password        : '1010',
  database        : 'cs340_karczj',
  dateStrings     : 'date'
  //dateStrings     :  true

});

module.exports.pool = pool;
