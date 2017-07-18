require 'open-uri'
require 'nokogiri'
require 'json'
require "net/https"
require "uri"

totalarr = Hash.new
filter = ["사건","세금","공헌","논란","체불","사태","감동","고객","자살","혐의","기소","봉사","기부"]

filter.each do |k|
  uri = URI(URI.encode("https://openapi.naver.com/v1/search/news.json?query=오뚜기#{k}&display=10&start=1&sort=sim"))
  req = Net::HTTP::Get.new(uri)
  req['X-Naver-Client-Id'] = ""
  req['X-Naver-Client-Secret'] = ""
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {
    |http| http.request(req)
  }

  gogo = JSON.parse(res.body)
  onetotal = gogo["total"]
  totalarr[onetotal] = "#{k}"
end


  uri = URI(URI.encode("https://openapi.naver.com/v1/search/news.json?query=오뚜기#{totalarr.sort.reverse[0][1]}&display=10&start=1&sort=sim"))
  req = Net::HTTP::Get.new(uri)
  req['X-Naver-Client-Id'] = ""
  req['X-Naver-Client-Secret'] = ""
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {
    |http| http.request(req)
  }

  gogo = JSON.parse(res.body)
  onetotal = gogo["items"]

  puts onetotal


# @news = gogo["items"]

# @news.each do |n|
#   url = n["link"]
#   data = Nokogiri::HTML(open(url))

#   unless data.at('meta[property="og:image"]').nil?
#     imgurl = data.at('meta[property="og:image"]')['content']
#   end

#   @jsonarray << {"title":n["title"], "description":n["description"], "imgurl":imgurl}
# end
# puts 'hi'
# puts @jsonarray.to_json
