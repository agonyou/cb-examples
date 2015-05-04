#####################################
### quick and dirty couchbase     ###
### stats page. (c) Austin Gonyou ###
############ couchbase 2015 #########

require 'rubygems'
require 'net/http'
require 'json'
#require 'yaji' ### A really great parser
require 'pp'

### Define Statistics URIs
#### Demo System URI
StatsURI = URI('http://54.177.90.130:8091/pools/default/buckets/event_stream/stats')
######----------------#######
#### Local System URI
#StatsURI = URI('http://localhost:8091/pools/default/buckets/travel-sample/stats')
statsResponse = Net::HTTP.get StatsURI
Stats = JSON.parse statsResponse

### Define Buckets URI
#### Demo System URI
BucketsURI = URI('http://54.177.90.130:8091/pools/default/buckets')
######----------------#######
#### Local System URI
#BucketsURI = URI('http://localhost:8091/pools/default/buckets')
bucketsResponse = Net::HTTP.get BucketsURI
Buckets = JSON.parse bucketsResponse

#### Begin basic HTML page with Table Output
puts '<html><head><meta http-equiv="refresh" content="6"><title>Couchbase Bucket Stats</title></head><body>'
puts '<table style="width:60%" border=1 color=red >'

#### Run through statistics to output samples keys and values
Stats.keys.each do |key,val| 
 sampKeys=Stats[key]
 if "#{key}" != "hot_keys"
   
   # Loop through bucket names
   Buckets.each do | bucket |
     
     # Filter out "Default" bucket for Local
     #if "#{bucket["name"]}" != "default" 

     # Filter out "Auction" bucket for Demo
     if "#{bucket["name"]}" != "Auction" 
     # Output non-default bucket name(s)
    puts "<h2>Bucket: #{bucket["name"]}</h2>"
      end
    end
    ##### output table header row
     puts "<tr><td><h3>Statistic Name</h3></td> <td><h3>First Sample</h3></td> <td><h3>Last Sample</h3></td> <td><h3>Difference</h3></td><tr>"
 end
 
 #### Loop through all samples from the "Status URL" above and output
   sampKeys["samples"].each do | sample , num|
       
       ### Filter any empty returns
       if sample != nil
         numDiff=num.first-num.last
          puts "<tr><td>#{sample}</td> <td><strong>#{num.first.to_i}</strong></td> <td><strong>#{num.last.to_i}</strong></td> <td><strong>#{numDiff.to_i.abs}</strong></td><tr>"
        end
     end
     ### End HTML table and Page output
 puts "</table></body></html>"
end


