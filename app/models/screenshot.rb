require 'uri'
require 'securerandom'

class Screenshot
  include Mongoid::Document

  field :url, :type => String
  field :uuid, :type => String
  field :callback_url, :type => String

  validates_presence_of :url
  validates_presence_of :uuid

  def self.create_with_uuid(params)
    create({:uuid => SecureRandom.uuid}.merge(params))
  end

  def self.from_uuid(uuid)
    where(:uuid => uuid).first
  end

  def url=(url)
    unless URI.parse(url.to_s).scheme
      url = "http://#{url}"
    end
    URI.parse(url)
    super
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
    Queue.push(uuid)
  end

  def shot_complete
    CallbackHandler.new(self).call
  end
end

