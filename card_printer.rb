require 'rubygems'
require 'sinatra'
require 'mingle4r'

get '/:username/:password' do
  mingle = MingleClient.new('http://minglehosting.thoughtworks.com/mpedigree_console/', params[:username], params[:password])
  mingle.proj_id = 'mpedigree_console'
  mingle.cards.inspect
end