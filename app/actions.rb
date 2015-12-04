
get '/' do

  conn = Faraday.new(headers: {accept_encoding: 'none'}, url: 'https://gateway-a.watsonplatform.net') do |faraday|
  # faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
end

# google search
articles = []

search_topic = "Pope"

search_response = RubyWebSearch::Google.search(:query => "#{search_topic} :site CNN", :size => 3)

search_response.results.each do |result| 
  article = {
    title: result[:title],
    url: result[:url]
  }
  articles.push(article)
end

#analyse with Alchemy

articles.each_with_index do |article, article_index|
  response = analyze_url(search_topic,article[:url])
  extract_sentiment(response, article_index)
end

def analyze_url (search_topic, url)
  conn.get "/calls/url/URLGetTargetedSentiment?apikey=4d314350027a4905e524e783e548a4e90a04c813&url=#{url}&outputMode=json&targets=#{search_topic}"
end


avg_score_arr = []


def extract_sentiment (response, article_index)
  return if response.body['status'] == "ERROR"
  articles[article_index][:score] = response.body['results'][0]['sentiment']['score'].to_f
  articles[article_index][:type] =  response.body['results'][0]['sentiment']['type']
  avg_score_arr.push(articles[article_index][:score])
end



# binding.pry
@average_sentiment_score = avg_score_arr.sum / avg_score_arr.size.to_f

if @average_sentiment_score > 0
  @average_sentiment_type = 'positive'
else
  @average_sentiment_type = 'negative'
end







# puts (@sentiment_type)
# puts (@sentiment_score)
  erb :index
end
