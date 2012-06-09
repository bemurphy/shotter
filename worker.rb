require './app'
require 'camera'

($queue || Queue).pop do |uuid|
  screenshot = Screenshot.from_uuid(uuid)
  camera = Camera.new
  camera.shoot(screenshot.url, screenshot.file_path)
  screenshot.shot_complete
end

