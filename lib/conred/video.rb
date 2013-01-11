require "conred/version"
require "action_view"
module Conred
  class Video
    def initialize(video_url, width = 670, height = 450, error_message = "Video url you have provided is invalid")
      @width = width
      @height = height
      @video_url = video_url
      @error_message = error_message
    end

    def code
      if youtube_video?
        video_from_youtube_url
      elsif vimeo_video?
        video_from_vimeo_url
      else
        @error_message
      end
    end

    def youtube_video?
      /^(http:\/\/)*(www\.)*(youtube.com|youtu.be)/ =~ @video_url ? true : false
    end

    def vimeo_video?
      /^(http:\/\/)*(www\.)*(vimeo.com)/ =~ @video_url ? true : false
    end


    def video_from_vimeo_url
      if @video_url[/vimeo\.com\/([0-9]*)/]
        @vimeo_id = $1
      end
      vimeo_file = "../views/video/vimeo_iframe"
      render(vimeo_file, :vimeo_id => @vimeo_id, :height => @height, :width => @width).html_safe
    end

    def video_from_youtube_url
      youtube_file = "../views/video/youtube_iframe"
      render(youtube_file, :youtube_id => youtube_id, :height => @height, :width => @width).html_safe
    end

    def render(path_to_partial, locals = {})
      path = File.join(
        File.dirname(__FILE__),
        path_to_partial.split("/")
      )
      Haml::Engine.new(File.read("#{path}.html.haml")).render(Object.new, locals)
    end

    def youtube_id
      if @video_url[/youtu\.be\/([^\?]*)/]
        youtube_id = $1
      else
        @video_url[/(v=([A-Za-z0-9_-]*))/]
        youtube_id = $2
      end
    end

  end
end