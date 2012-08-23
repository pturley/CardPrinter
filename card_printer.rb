require 'rubygems'
require 'sinatra'
require 'mingle4r'
require 'nokogiri'
require 'open-uri'

get '/:username/:password/:story' do
  @doc = Nokogiri::XML(open("https://minglehosting.thoughtworks.com/mpedigree_console/api/v2/projects/mpedigree_console/cards/" + params[:story] + ".xml", :http_basic_authentication=>[params[:username], params[:password]]))
  "<html>
  <head>
    <title>Story Wall | Card Printer</title>
    <link rel='stylesheet' href='http://www.wattrus.co.za/MinglePrinter/css/StoryWall.css' />
  </head>
  <body>
  <div class='story-wall'>
    <span class='title'>Story Wall</span>
    <hr />
    <span class='links'>Card Printer</span>
  </div>
  <div class='Card' id='printable'>
    <textarea class='title' id='card_title'>" + @doc.xpath("//name")[0] + "</textarea>
    <input type='text' class='number' value='#" + @doc.xpath("//number")[0] + "' />
    <input type='text' class='size' value='M' />
    <input type='text' class='status' value='M' />
  </div>
  </body>
  </html>"
end
