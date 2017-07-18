require 'open-uri'
require 'nokogiri'
require 'json'
require "net/https"
require "uri"

class NewsController < ApplicationController
  # before_action :set_news, only: [:show, :update, :destroy]

  # GET /news
  def index
    @jsonarray = []
    uri = URI(URI.encode("https://openapi.naver.com/v1/search/news.json?query=기저귀독성&display=10&start=1&sort=sim"))
    req = Net::HTTP::Get.new(uri)
    req['X-Naver-Client-Id'] = ""
    req['X-Naver-Client-Secret'] = ""

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {
      |http| http.request(req)
    }


    gogo = JSON.parse(res.body)

    @news = gogo["items"]

    @news.each do |n|
      url = n["link"]
      data = Nokogiri::HTML(open(url))

      unless data.at('meta[property="og:image"]').nil?
        imgurl = data.at('meta[property="og:image"]')['content']
      end

      @jsonarray << {"title":n["title"], "description":n["description"], "imgurl":imgurl, "link":url}
    end

    render json: @jsonarray

  end

  # GET /news/1
  def show


  totalarr = Hash.new
  filter = ["세금","사건","논란","체불","기소","봉사","기부","공헌","감동","혁신"]
  @jsonarray = []

  filter.each do |k|
    uri = URI(URI.encode("https://openapi.naver.com/v1/search/news.json?query=#{params[:id] + k}&display=10&start=1&sort=sim"))
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


    uri = URI(URI.encode("https://openapi.naver.com/v1/search/news.json?query=#{params[:id] + totalarr.sort.reverse[0][1]}&display=10&start=1&sort=sim"))
    req = Net::HTTP::Get.new(uri)
    req['X-Naver-Client-Id'] = ""
    req['X-Naver-Client-Secret'] = ""
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {
      |http| http.request(req)
    }

    gogo = JSON.parse(res.body)

    @news = gogo["items"]

    @news.each do |n|
      url = n["link"]
      data = Nokogiri::HTML(open(url))

      unless data.at('meta[property="og:image"]').nil?
        imgurl = data.at('meta[property="og:image"]')['content']
      end

      @jsonarray << {"title":n["title"], "description":n["description"], "imgurl":imgurl, "link":url}
    end

    render json: @jsonarray

  end

  def searchresult
    redirect_to "/"
  end

  def detail

  end

  # POST /news
  def create
    @news = News.new(news_params)

    if @news.save
      render json: @news, status: :created, location: @news
    else
      render json: @news.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /news/1
  def update
    if @news.update(news_params)
      render json: @news
    else
      render json: @news.errors, status: :unprocessable_entity
    end
  end

  # DELETE /news/1
  def destroy
    @news.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
    end

    # Only allow a trusted parameter "white list" through.
    def news_params
      params.fetch(:news, {})
    end
end
