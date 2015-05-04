#!/usr/bin/env ruby

require 'rubygems'
require 'couchbase'
require 'json'
require 'pp'
require 'ruby-progressbar'
require "optparse"

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "ruby json loader"

  opts.on('-f', '--jsonfile jsonfile', 'JSON formatted filename') do |jsonfile|
    options[:jsonfile] = jsonfile
  end

    opts.on("-b", "--bucketname BUCKETNAME", "bucket name") do |bucketname|
      options[:bucketname] = bucketname
    end

    opts.on("-h", "--hostname hostname", "hostname/ip address") do |hostname|
      options[:hostname] = hostname
    end
    opts.on(nil){puts opts;exit}
end

optparse.parse!


json_file=options[:jsonfile]
Bucket=options[:bucketname]
Host=options[:hostname]

#Connect to couchbase host and bucket provided on the command line
Client=Couchbase.connect(:bucket=>Bucket.to_s, :host=>Host)

##Create the progressbar
progressbar=ProgressBar.create(:title => "Doc Load",
                               :starting_at => 0,
                               :total => nil,
                               :throttle_rate => 0.01,
                               :format => '%a |%b>>%i| %p%% %t',
                               :length => 50)

InputFile=File.open(json_file) 
#docs=JSON.load(InputFile)

#IO.foreach(InputFile) do |line|
InputFile.each do |line|
a=pp(line)
#doc=JSON.parse(a,:max_nesting => false,:allow_nan => true, :symbolize_names => true)
b=JSON.parse(a)
doc=b
doc.to_json
   Client.set(doc.hash.to_s,doc)
   #puts(line.hash.to_s,line)
   progressbar.increment
#puts doc 
end
