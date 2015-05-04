#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'pp'
require 'couchbase'
require 'securerandom'
require 'ruby-progressbar'
require "optparse"

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: [options]"

  opts.on('-f', '--jsonfile jsonfile', 'JSON formatted filename') { |jsonfile|
    options[:jsonfile] = jsonfile}

    opts.on("-b", "--bucketname BUCKETNAME", "Couchbase bucket name") { |bucketname|
      options[:bucketname] = bucketname}

    opts.on("-h", "--hostname hostname", "Couchbase hostname/ip address") { |hostname|
      options[:hostname] = hostname}

    opts.on("-i","--info") {puts opts; exit}
    
end
optparse.parse!



Json_File=options[:jsonfile]
Bucket=options[:bucketname]
Host=options[:hostname]


puts "Connecting to Couchbase"
# 1.3.10 client
#Connect to couchbase host and bucket provided on the command line
Client=Couchbase.connect(:bucket=>Bucket.to_s, :host=>Host)

#2.0 client
#cluster = Couchbase::Cluster.new('localhost')
#bucket = cluster.open_bucket('KCMOPS311')


puts "opening workfile..."
json_file = File.read(Json_File)
puts "hashing workfile..."
data_hash = JSON.parse(json_file)
puts "openened workfile..."

data_hash.to_json
docs=data_hash.length

#Create the progressbar
progressbar=ProgressBar.create(:title => "Doc Load", 
			       :starting_at => 0, 
			       :total => docs,
			       :throttle_rate => 0.01,
			       :format => '%a |%b>>%i| %p%% %t',
			       :length => 50)

(1..docs).each { |docnum| 
#1.3.10 code
	Client.set(data_hash[docnum].hash.to_s,data_hash[docnum])
#2.0 code
	#bucket.set(data_hash[docnum].hash.to_s,data_hash[docnum])

progressbar.increment
 }
progressbar.finished?

#puts JSON.pretty_generate(data_hash)
comp_client.disconnect
