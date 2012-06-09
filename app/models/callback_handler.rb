require 'restclient'

class CallbackHandler
  def initialize(screenshot)
    @screenshot = screenshot
  end

  def call
    return unless @screenshot.callback_url

    RestClient.post @screenshot.callback_url, post_data.to_json,
      :content_type => :json, :accept => :json
  end

  private

  def post_data
    #TODO get some real status in here
    {
      :uuid => @screenshot.uuid,
      :status => "success"
    }
  end
end

