
get '/' do

  conn = Faraday.new(headers: {accept_encoding: 'none'}, url: 'https://gateway-a.watsonplatform.net') do |faraday|
  # faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
end

# google search
search_topic = "Pope"
titles = []
urls = []
search_response = RubyWebSearch::Google.search(:query => "#{search_topic} :site CNN", :size => 3)
search_response.results.each do |result| 
titles.push(result[:title])  
urls.push(result[:url])

end



@myUrl1 = urls[0]
@myUrl2 = urls[1]
@myUrl3 = urls[2]


@myTitle1 = titles[0]
@myTitle2 = titles[1]
@myTitle3 = titles[2]

#analyse with Alchemy

def analyze_url (search_topic, url)
  conn.get "/calls/url/URLGetTargetedSentiment?apikey=4d314350027a4905e524e783e548a4e90a04c813&url=#{url}&outputMode=json&targets=#{search_topic}"
end


avg_score_arr = []


def extract_sentiment
  response = analyze_sentiment(params)
  unless response.body['status']=="ERROR"
    sentiment_score = response.body['results'][0]['sentiment']['score'].to_f
    sentiment_type =  response.body['results'][0]['sentiment']['type']
    avg_score_arr.push(sentiment_score)
  end
end

if ((@sentiment_type1 && @sentiment_type2) || (@sentiment_type1 && @sentiment_type3) || (@sentiment_type2 && @sentiment_type3)) == 'positive'
  @average_sentiment_type = 'positive'
else
  @average_sentiment_type = 'negative'
end


# binding.pry
@average_sentiment_score = avg_score_arr.sum / avg_score_arr.size.to_f






# puts (@sentiment_type)
# puts (@sentiment_score)
  erb :index
end
