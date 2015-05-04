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

opts.on('-r', '--root JSONroot', 'JSON root id') do |root|
options[:root] = root
 end

opts.on('-h', '--help', 'This menu') { puts opts; exit}
end
 
optparse.parse!
 
json_file = options[:jsonfile]
bucket = options[:bucketname]
host = options[:hostname]
root = options[:root] 
unless root
    root="/"
end
puts "JSON path processed is #{root}"
 
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
#puts YAJI.pretty_generate(doc)
client.set(doc.hash.to_s, doc)
print("\r#{i}")
progressbar.increment
end
progressbar.finished?
puts
