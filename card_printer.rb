require 'rubygems'
require 'sinatra'
require 'mingle4r'
require 'nokogiri'
require 'open-uri'
require 'card'

enable :sessions

get '/' do
  haml :login
end

post '/get_cards' do
  session[:username] = params[:username]
  session[:password] = params[:password]
  session[:mingle_instance_url] = params[:mingle_instance_url]
  session[:project_name] = params[:project_name]
  session[:estimate_field] = params[:estimate_field]
  session[:card_numbers] = params[:card_numbers]
  redirect "/cards"
end

# Example:
  #   mingle_instance_url: https://minglehosting.thoughtworks.com/mpedigree_console
  #   project_name: mpedigree_console
get '/cards' do
  redirect "/" if session[:username].empty? || session[:password].empty? || session[:mingle_instance_url].empty? || session[:project_name].empty? || session[:estimate_field].empty?

  @cards = []
  begin
    unless session[:card_numbers].empty?
        session[:card_numbers].split(",").map{|number| number.lstrip.rstrip}.uniq.reject(&:empty?).each do |card_number|
          doc = Nokogiri::XML(
            open("#{session[:mingle_instance_url]}/api/v2/projects/#{session[:project_name]}/cards/#{card_number}.xml", 
              :http_basic_authentication=>[session[:username], session[:password]]))
          @cards << Card.new(doc.xpath("//card"), session[:estimate_field])
        end
    else
      doc = Nokogiri::XML(
        open("#{session[:mingle_instance_url]}/api/v2/projects/#{session[:project_name]}/cards.xml?filters[]=[Type][is][Story]", 
          :http_basic_authentication=>[session[:username], session[:password]]))
      @cards = doc.xpath("//card").map{|card_doc| Card.new(card_doc, session[:estimate_field])}
    end
  rescue OpenURI::HTTPError => e
    redirect "/bad_data"
  end

  haml :cards
end

get "/bad_data" do
  haml :bad_data
end