BingSearch.account_key = 'hqXahx+6k2dIwnykE26HCrEItoUXM8JmiVB1QBocMhA'
require_relative'../cache/cache.rb'
# require_relative'../cache/cache.rb'

get '/' do

  search_topic = params[:topic]
  @articles = []
  @avg_score_arr = []
  media = params[:media]

  if search_topic

    @conn = Faraday.new(headers: {accept_encoding: 'none'}, url: 'https://gateway-a.watsonplatform.net') do |faraday|
      # faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
    end

  #-------------get general sentiment of article-------#

    def analyze_url_non_targeted (url)
      @conn.get "/calls/url/URLGetTextSentiment?apikey=bc9d67cc85047b79b30187500483a6212581839d&url=#{url}&outputMode=json&showSourceText=1&sourceText=cleaned"
    end

  #----------extract seniment--------#

    def extract_sentiment (response, article_index)
      return if response.body['status'] == "ERROR"
      @articles[article_index][:score] = response.body['docSentiment']['score'].to_f
      @articles[article_index][:type] =  response.body['docSentiment']['type']
      @articles[article_index][:content] =  response.body['text'].gsub('"','&quot;')
      @avg_score_arr.push(@articles[article_index][:score])
    end




    if search_topic == 'syria'
      @articles = @@array_response_syria
    elsif search_topic == 'donald trump'
      @articles = @@array_response_donald_trump
    else
    # ---- search bing with topic and return general selection-------- #
    if media == "ALL"
      search_response = BingSearch.news("#{search_topic}" , limit: 10, sort:"relevance")
      # --------- parse responses ------- #
      search_response.each do |result| 
        article = {
          title: result.title,
          url: result.url,
          source: result.source
        }
        @articles.push(article)
      end
   # ---- search google with topic and return media specific selection-------- #   
    else
      search_response = RubyWebSearch::Google.search(:query => "#{search_topic} :site #{media}", :size => 5)
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
     article[:normalized_score_absolute] = (article[:score] + 1) * 50
    end

    @articles.each do |article|
     article[:normalized_score_relative] = (( article[:score] - @articles[0][:score] ) / ( @articles[-1][:score] - @articles[0][:score])) * 90
    end
  # File.write('cache/cache.rb', @articles, mode: 'a')
  # search_topic_underscore = search_topic.gsub(' ','-')
  # topic_array.push(search_topic_underscore)
  end

  end


  erb :index
end
