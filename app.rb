require 'sinatra'
require 'rack/parser'
require 'json'
require 'mongoid'
require 'bunny'

$:.unshift File.join(File.dirname(__FILE__), 'app', 'models')
Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each {|file| require file }

Mongoid.load!("./mongoid.yml")

use Rack::Parser

get "/shot/:uuid.png" do
  content_type 'image/png'
  screenshot = Screenshot.from_uuid(params["uuid"])
  screenshot.raw_file
end

post "/shots.json" do
  content_type :json

  url = params.fetch("url")
  screenshot = Screenshot.create_with_uuid(:url => url, :callback_url => params["callback_url"])
  if screenshot.valid?
    screenshot.request_shot

    { :status => "ok", :uuid => screenshot.uuid }.to_json
  else
    { :status => "error" }.to_json
  end
end