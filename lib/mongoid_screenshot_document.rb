class MongoidScreenshotDocument
  include Mongoid::Document

  field :url, :type => String
  field :uuid, :type => String
  field :callback_url, :type => String

  validates_presence_of :url
  validates_presence_of :uuid

  def self.find_by_uuid(uuid)
    where(:uuid => uuid).first
  end
end
