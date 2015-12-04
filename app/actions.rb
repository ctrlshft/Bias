# require 'ruby-web-search'

# Homepage (Root path)
get '/' do

  conn = Faraday.new(headers: {accept_encoding: 'none'}, url: 'https://gateway-a.watsonplatform.net') do |faraday|
  # faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
end

@titles = []
search_response = RubyWebSearch::Google.search(:query => "Putin:CNN")
search_response.results.each do |result| 
@titles.push(result[:title])  
end



myUrl = 'http://www.aljazeera.com/news/2015/07/palestinians-bury-baby-killed-west-bank-arson-attack-150731130550655.html'

response = conn.get "/calls/url/URLGetTargetedSentiment?apikey=4d314350027a4905e524e783e548a4e90a04c813&url=#{myUrl}&outputMode=json&targets=israel"


@sentiment_score = response.body['results'][0]['sentiment']['score']
@sentiment_type = response.body['results'][0]['sentiment']['type']



puts (@sentiment_type)
puts (@sentiment_score)
  erb :index
end
