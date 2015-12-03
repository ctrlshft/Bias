

# Homepage (Root path)
get '/' do

  conn = Faraday.new(headers: {accept_encoding: 'none'}, url: 'https://gateway-a.watsonplatform.net') do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
end

response = conn.get '/calls/data/GetNews?outputMode=json&start=now-30d&end=now&count=10&q.enriched.url.enrichedTitle.keywords.keyword.text=paintings&return=enriched.url.url,enriched.url.title&apikey=974094b83de2749ddb09bee46a068e273cb4734d'

binding.pry


@response1 = response.body
  erb :index
end
