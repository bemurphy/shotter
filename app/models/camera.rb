require 'shellwords'
require 'callback_handler'

class Camera
  def shoot(screenshot)
    @screenshot = screenshot

    shot = IO.popen("casperjs screenshot.js #{url} #{file_path}")
    shot.readlines
    shot.close

    screenshot.shot_complete
    screenshot.file_path
  end

  def url
    escape @screenshot.url
  end

  def file_path
    escape @screenshot.file_path
  end

  def escape(string)
    Shellwords.shellescape string.to_s
  end
end

