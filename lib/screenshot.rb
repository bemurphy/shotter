require 'uri'
require 'securerandom'
require 'callback_handler'
require 'forwardable'

class Screenshot
  extend Forwardable

  def_delegators :@document, :url, :uuid, :callback_url
  def_delegators :@document, :valid?

  def initialize(screenshot_document)
    @document = screenshot_document
  end

  class << self
    attr_writer :queue, :document_class

    def queue
      @queue || Queue
    end

    def document_class
      @document_class || MongoidScreenshotDocument
    end
  end

  def self.create_with_uuid(params)
    params[:url] = sanitize_url params[:url]
    new document_class.create({:uuid => SecureRandom.uuid}.merge(params))
  end

  def self.from_uuid(uuid)
    #TODO raise if the uuid is not locatable
    new(document_class.find_by_uuid(uuid))
  end

  def file_path
    "/tmp/#{uuid}.png"
  end

  def file
    File.open(file_path, "r")
  end

  def raw_file
    file.readlines
  end

  def request_shot
    self.class.queue.push(uuid)
  end

  def shot_complete
    CallbackHandler.new(self).call
  end

  protected

  # TODO this should be cleaner.  I don't like having it
  # as a class method, something is wrong...
  def self.sanitize_url(url)
    unless URI.parse(url.to_s).scheme
      url = "http://#{url}"
    end
    URI.parse(url)
    url
  end
end

