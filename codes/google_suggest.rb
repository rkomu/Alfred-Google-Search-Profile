require 'cgi'
require 'json'
require 'net/http'
require 'uri'

Encoded = CGI.escape(ARGV[0])
Query_url = "https://suggestqueries.google.com/complete/search?output=firefox&q=#{Encoded}"
Results = JSON.parse(Net::HTTP.get(URI.parse(Query_url)))[1] 

if Results.empty?
  puts({ items: [{ title: 'No suggestions found', subtitle: 'Try searching something else', valid: false },{ title: ARGV[0], subtitle: "Search “#{ARGV[0]}” on Google", arg: ARGV[0] }] }.to_json)
  exit 0
end


array_num = 0

Script_filter_items = Results.each_with_object([]) { |result, array|
  if array_num == 0 then
	  array.push(
	    title: ARGV[0],
    		subtitle: "Search “#{ARGV[0]}” on Google",
    		arg: ARGV[0]
  	  ) 
  end
  array.push(
    title: result,
    subtitle: "Search “#{result}” on Google",
    arg: result
  )
  array_num += 1
}

puts({ items: Script_filter_items }.to_json)