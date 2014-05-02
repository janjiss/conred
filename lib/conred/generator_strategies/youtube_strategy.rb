class Conred::Video::YoutubeStrategy
  include Conred::Video

  def self.url_format_is_valid? url
    /^(http|https)*(:\/\/)*(www\.)*(youtube.com|youtu.be)/ =~ url
  end

  def api_uri
    "//gdata.youtube.com/feeds/api/videos/#{@video_id}"
  end

  def video_link
    "//www.youtube.com/embed/#{@video_id}?wmode=transparent"
  end

  private

  def get_video_id_from url
    if url[/youtu\.be\/([^\?]*)/]
      video_id = $1
    else
      url[/(v=([A-Za-z0-9_-]*))/]
      video_id = $2
    end
  end
end