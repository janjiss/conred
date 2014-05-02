class Conred::Video::VimeoStrategy
  include Conred::Video

  def self.url_format_is_valid? url
    /^(http|https)*(:\/\/)*(www\.)*(vimeo.com)/ =~ url
  end

  def api_uri
    "//vimeo.com/api/v2/video/#{@video_id}.json"
  end

  def video_link
    "//player.vimeo.com/video/#{@video_id}"
  end

  private

  def get_video_id_from url
    url[/vimeo\.com\/([0-9]*)/]
    @video_id = $1
  end
end