require "conred/version"
require "action_view"
require "conred/helpers"
require "conred/video"
require "conred/links"
require "haml"
module Conred
  def Video.new arguments
    if Video::Youtube.url_format_is_valid? arguments[:video_url]
      Video::Youtube.new arguments
    elsif Video::Vimeo.url_format_is_valid? arguments[:video_url]
      Video::Vimeo.new arguments
    else
      Video::Other.new arguments
    end
  end
end
