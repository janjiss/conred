class Conred::Video::OtherStrategy
  include Conred::Video
  def initialize(arguments = {:error_message => "Video url you have provided is invalid"})
    @error_message = arguments[:error_message]
  end

  def code
    @error_message
  end

  def exist?
    false
  end

  def self.url_format_is_valid? url
    true
  end
end