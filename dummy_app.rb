require 'sinatra'
require 'json'
require 'rack/parser'

use Rack::Parser

post "/shot_callbacks" do
  content_type :json
  puts params.inspect
  { :status => "ok" }.to_json
end
