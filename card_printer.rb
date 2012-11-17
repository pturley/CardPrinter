require 'rubygems'
require 'sinatra'
require 'mingle4r'
require 'nokogiri'
require 'open-uri'

post '/' do
  puts params
  username = params[:username]
  password = params[:password]
  number = params[:card_number]
  doc = Nokogiri::XML(
    open("https://minglehosting.thoughtworks.com/mpedigree_console/api/v2/projects/mpedigree_console/cards/#{number}.xml", 
      :http_basic_authentication=>[username, password]))
  @name = doc.xpath("//name")[0].text
  @number = doc.xpath("//number")[0].text
  haml :home
end

get '/card_printer' do
  haml :card_printer
end

