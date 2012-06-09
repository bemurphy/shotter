require 'shellwords'
require 'callback_handler'

class Camera
  def shoot(url, file_path)
    url = escape url
    file_path = escape file_path

    shot = IO.popen("casperjs screenshot.js #{url} #{file_path}")
    shot.readlines
    shot.close

    file_path
  end

  def escape(string)
    Shellwords.shellescape string.to_s
  end
end

