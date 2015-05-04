/**
 * @author Austin Gonyou
 */

var couchbase = require("couchbase");

// Connect to Couchbase Server

var cluster = new couchbase.Cluster('couchbase://127.0.0.1');
var bucket = cluster.openBucket('travel-sample', function(err) {
  if (err) {
    // Failed to make a connection to the Couchbase cluster.
    throw err;
  };

  // Retrieve a document

  bucket.get('airline_10123', function(err, result) {
    if (err) {
      // Failed to retrieve key
      throw err;
    }

    var doc = result.value;

    console.log(doc.name + ', ID: ' + doc.callsign + ' comment: ' + doc.comment);
    
    // Store a document

    doc.comment = "Random Texas Airline";

    bucket.replace('airline_10123', doc, function(err, result) {
      if (err) {
        // Failed to replace key
        throw err;
      }

      console.log(result);

      // Success!
      process.exit(0);
    });
  });
});