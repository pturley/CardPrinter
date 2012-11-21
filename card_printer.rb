require 'rubygems'
require 'sinatra'
require 'mingle4r'
require 'nokogiri'
require 'open-uri'

post '/' do
  page = "all"
  doc = Nokogiri::XML(
    open("#{params[:project_url]}/cards.xml?filters[]=[Type][is][Story]&page=#{page}", 
      :http_basic_authentication=>[params[:username], params[:password]]))

  @cards = doc.xpath("//card")

  haml :cards
end

get '/' do
  haml :login
end

