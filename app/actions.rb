BingSearch.account_key = 'hqXahx+6k2dIwnykE26HCrEItoUXM8JmiVB1QBocMhA'

#search ten top articles on topic
#extract sentiment
#calculate max sentiment difference
#display the 2 max sentiment difference articles
#calculate 2nd biggest sentiment difference and provide those articles as option
#calculate 3nd biggest sentiment difference and provide those articles as option


#or create new sentiment scale based on biggest difference and populate

#strech - provide sentiment map for all search results? or 2 views. one - relative sentiment, two - absolute sentiment.switchable


get '/' do

  @conn = Faraday.new(headers: {accept_encoding: 'none'}, url: 'https://gateway-a.watsonplatform.net') do |faraday|
    # faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
  end

#-------------get general sentiment of article-------#

  def analyze_url_non_targeted (url)
    @conn.get "/calls/url/URLGetTextSentiment?apikey=4d314350027a4905e524e783e548a4e90a04c813&url=#{url}&outputMode=json&showSourceText=1&sourceText=cleaned"
  end

#----------extract seniment--------#

  def extract_sentiment (response, article_index)
    return if response.body['status'] == "ERROR"
    @articles[article_index][:score] = response.body['docSentiment']['score'].to_f
    @articles[article_index][:type] =  response.body['docSentiment']['type']
    @articles[article_index][:content] =  response.body['text']
    @avg_score_arr.push(@articles[article_index][:score])
  end

  @articles = []

  @avg_score_arr = []

  news_sources = ["cnn",
                  "cbc",
                  "al jazeera",
                  "bbc",
                  "new york times",
                  "washington post",
                  "vice",
                  "toronto sun",
                  "rt news",
                  "infowars",
                  "haaretz"

                ]

  search_topic = params[:topic]
  media_source = params[:newssources]


# ---- search bing with topic -------- #
  # news_sources.each do |source|
  if media_source == "ALL"
    search_response = BingSearch.news("#{search_topic}" , limit: 10, sort:"date")
    # --------- parse responses ------- #
    search_response.each do |result| 
      article = {
        title: result.title,
        url: result.url,
        source: result.source
      }
      @articles.push(article)
    end
    
  else
    search_response = RubyWebSearch::Google.search(:query => "#{search_topic} :site #{media_source}", :size => 5)
  # ----- parse responses ----- #
    search_response.results.each do |result| 
      article = {
        title: result[:title],
        url: result[:url],
        source: result[:domain]
      }
      @articles.push(article)
    end
 
  end


  # end

# ---- send to alchemy for analysis sentiment extraction ----#
  @articles.each_with_index do |article, article_index|
    response = analyze_url_non_targeted(article[:url])
    extract_sentiment(response, article_index)
  end


# ------ average sentiment score of all articles ----- #
  @average_sentiment_score = @avg_score_arr.sum / @avg_score_arr.size.to_f


# ----- average sentiment type of all articles ----- #
  if @average_sentiment_score > 0
    @average_sentiment_type = 'positive'
  else
    @average_sentiment_type = 'negative'
  end



 
# # --- sort by sentiment scores and find sentiment range (will plot by relative sentiment----#

  @articles = @articles.reject {|article| (article[:score] == nil)||(article[:score] == 0)}
  @articles = @articles.sort_by { |hsh| hsh[:score] }
  

  @articles.each do |article|
   article[:normalized_score_absolute] = (article[:score] - @articles[0][:score]) * 50
  end


  # sentiment_range = @articles.first[:score] - @articles.last[:score]
  @articles.each do |article|
   article[:normalized_score_relative] = (( article[:score] - @articles[0][:score] ) / ( @articles[-1][:score] - @articles[0][:score])) * 100
  end




  erb :index
end
