require 'rubygems'
require 'net/http'
require 'json'
require 'yaji'
require 'pp'

#uri = URI('https://api.github.com/users/octocat')
#uri = URI('http://localhost:8091/pools/default/buckets/orders_user/nodes/127.0.0.1%3A8091/stats?samplesCount=1')
uri = URI('http://localhost:8091/pools/default')
response = Net::HTTP.get uri
#octocat = JSON.parse response

octocat = YAJI::Parser.new(response)

octocat.keys.each.with_index do |key,i| 
  
 # pp "#{key} #{val}"
   pp "#{key["#{i}"]} \n "

end

