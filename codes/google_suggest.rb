require 'cgi'
require 'json'
require 'net/http'
require 'uri'

Encoded = CGI.escape(ARGV[0])
Query_url = "https://suggestqueries.google.com/complete/search?output=firefox&q=#{Encoded}"
Results = JSON.parse(Net::HTTP.get(URI.parse(Query_url)))[1]

if Results.empty?
  puts({ items: [{ title: 'No suggestions found', subtitle: 'Try searching something else', valid: false }] }.to_json)
  exit 0
end

Script_filter_items = Results.each_with_object([]) { |result, array|
  array.push(
    title: result,
    subtitle: "Search “#{result}” on Google",
    arg: result
  )
}

puts({ items: Script_filter_items }.to_json)