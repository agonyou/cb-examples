#!/usr/bin/env ruby
 
#Test JSON file is at:
# https://github.com/ysharplanguage/FastJsonParser/raw/master/JsonTest/TestData/fathers.json.txt

require 'ruby-progressbar'
require 'rubygems'
require 'couchbase'
require 'yaji'
require 'optparse'
 
options = {}
 
optparse = OptionParser.new do |opts|
opts.banner = 'ruby json loader'
 
opts.on('-f', '--jsonfile jsonfile', 'JSON formatted filename') do |jsonfile|
options[:jsonfile] = jsonfile
end
 
opts.on('-b', '--bucketname BUCKETNAME', 'bucket name') do |bucketname|
options[:bucketname] = bucketname
end
 
opts.on('-n', '--hostname hostname', 'hostname/ip address') do |hostname|
options[:hostname] = hostname
 end

opts.on('-r', '--root JSONroot', 'JSON root to parse') do |root|
options[:root] = root
 end

opts.on('-d', '--docid SearchKey', 'JSON Key ID') do |docid|
options[:docid] = docid
 end

opts.on('-h', '--help', 'This menu') { puts opts; exit}
end
 
optparse.parse!
 
json_file = options[:jsonfile]
bucket = options[:bucketname]
host = options[:hostname]
root = options[:root] 
docid = options[:docid]

#set some defaults if not passed
unless host
      host=localhost
end

unless root
    root="/"
end

puts "Reading from #{json_file}"
puts "JSON path processed is #{root}"
puts "Couchbase  node is #{host}"
 
# Connect to couchbase host and bucket provided on the command line
client = Couchbase.connect(:bucket => bucket, :host => host)

#Create the progressbar
progressbar=ProgressBar.create(:title => "Doc Load",
                               :starting_at => 0,
                               :total => nil,
                               :throttle_rate => 0.01,
                               :format => '%a |%b>>%i| %p%% %t',
                               :length => 50)
 
parser = YAJI::Parser.new(File.open(json_file))

  parser.each(root.to_s).with_index do |doc,i|
  unless docid
     hashinfo=doc.hash.abs
     prikey="Doc_#{i}:#{hashinfo}"
  end
prikey="#{docid}:#{doc["#{docid}"]}"

  client.set("#{prikey}", doc)
  print("\r#{i} ")
  progressbar.increment
  end
#end 
progressbar.finished?
puts
