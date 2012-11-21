require 'rubygems'
require 'sinatra'
require 'mingle4r'
require 'nokogiri'
require 'open-uri'
require 'card'

post '/' do
  page = "all"
  doc = Nokogiri::XML(
    #https://minglehosting.thoughtworks.com/mpedigree_console/api/v2/projects/mpedigree_console
    open("#{params[:mingle_instance_url]}/api/v2/projects/#{params[:project_name]}/cards.xml?filters[]=[Type][is][Story]&page=#{page}", 
      :http_basic_authentication=>[params[:username], params[:password]]))

  @cards = doc.xpath("//card").map{|card_doc| Card.new(card_doc, params[:estimate_field])}

  haml :cards
end

get '/' do
  haml :login
end

