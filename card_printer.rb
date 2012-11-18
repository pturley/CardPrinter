require 'rubygems'
require 'sinatra'
require 'mingle4r'
require 'nokogiri'
require 'open-uri'

post '/' do
  doc = Nokogiri::XML(
    open("https://minglehosting.thoughtworks.com/mpedigree_console/api/v2/projects/mpedigree_console/cards.xml?filters[]=[Type][is][Story]&page=all", 
      :http_basic_authentication=>[params[:username], params[:password]]))

  @cards = doc.xpath("//card")

  haml :cards
end

get '/' do
  haml :login
end

