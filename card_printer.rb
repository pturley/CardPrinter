require 'rubygems'
require 'sinatra'
require 'mingle4r'
require 'nokogiri'
require 'open-uri'
require 'card'

post '/' do
  # Example:
  #   mingle_instance_url: https://minglehosting.thoughtworks.com/mpedigree_console
  #   project_name: mpedigree_console
  @cards = []
  unless params[:card_numbers].empty?
    params[:card_numbers].split(",").map{|number| number.lstrip.rstrip}.uniq.reject(&:empty?).each do |card_number|
      doc = Nokogiri::XML(
        open("#{params[:mingle_instance_url]}/api/v2/projects/#{params[:project_name]}/cards/#{card_number}.xml", 
          :http_basic_authentication=>[params[:username], params[:password]]))
      @cards << Card.new(doc.xpath("//card"), params[:estimate_field])
    end
  else
    doc = Nokogiri::XML(
      open("#{params[:mingle_instance_url]}/api/v2/projects/#{params[:project_name]}/cards.xml?filters[]=[Type][is][Story]", 
        :http_basic_authentication=>[params[:username], params[:password]]))
    @cards = doc.xpath("//card").map{|card_doc| Card.new(card_doc, params[:estimate_field])}
  end

   

  haml :cards
end

get '/' do
  haml :login
end

