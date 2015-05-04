/**
 * @author Austin Gonyou
 */

var couchbase = require('couchbase');
var N1qlQuery = couchbase.N1qlQuery;
//var myCluster = new couchbase.Cluster('http://localhost:8091');
var myCluster = new couchbase.Cluster('http://54.177.61.196:8091');
var myBucket = myCluster.openBucket('travel-sample');

myBucket.enableN1ql('http://54.177.61.196:8093');

Newquery = N1qlQuery.fromString('SELECT faa FROM `travel-sample` where faa  like \'A%\' and faa is not null ');
//Newquery = N1qlQuery.fromString('SELECT faa FROM `travel-sample` where faa  like \'A%\' and faa is not null and not CONTAINS(faa, ([0-9])) order by faa desc ');



myBucket.query(Newquery, function(err, res) {
  if (err) {
    console.log('query failed', err);
    return;
  }
  console.log('success!', res);
  return;

});


