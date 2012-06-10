require 'sinatra'
require 'rack/parser'
require 'json'

$:.unshift File.join(File.dirname(__FILE__), 'lib')
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

use Rack::Parser

get "/shot/:uuid.png" do
  if screenshot = Screenshot.from_uuid(params["uuid"])
    content_type 'image/png'
    screenshot.raw_file
  else
    halt 404, "Not found"
  end
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
