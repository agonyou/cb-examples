require 'rubygems'
require 'couchbase'

client = Couchbase.connect(:bucket => "beer-sample", :host => "localhost")

beer = client.get("aass_brewery-juleol")
puts "#{beer['name']}, ABV: #{beer['abv']}"

beer['comment'] = "Random beer from Norway"
client.replace("aass_brewery-juleol", beer)

client.disconnect
