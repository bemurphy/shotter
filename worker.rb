require './app'
require 'camera'

Queue.subscribe do |msg|
  uuid = msg[:payload]
  screenshot = Screenshot.from_uuid(uuid)
  camera = Camera.new
  camera.shoot(screenshot)
end


