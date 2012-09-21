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
      if /^(http:\/\/)*(www\.)*(youtube.com|youtu.be)/ =~ @video_url
        true
      end
    end

    def vimeo_video?
      if /^(http:\/\/)*(www\.)*(vimeo.com)/ =~ @video_url
        true
      else
        false
      end
    end


    def video_from_vimeo_url
      if @video_url[/vimeo\.com\/([0-9]*)/]
        vimeo_id = $1
      end
      <<-eos
      <iframe
        id='vimeo_video'
        src='http://player.vimeo.com/video/#{vimeo_id}'
        width='#{@width}' 
        height='#{@height}'
        frameborder='0'
        webkitAllowFullScreen
        mozallowfullscreen
        allowFullScreen>
      </iframe>
      eos
      .html_safe
    end

    def video_from_youtube_url
      if @video_url[/youtu\.be\/([^\?]*)/]
          youtube_id = $1
      else
        @video_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
        youtube_id = $5
      end
      <<-eos
      <iframe
        id='youtube_video'
        title='YouTube video player' 
        width='#{@width}' 
        height='#{@height}' 
        src='http://www.youtube.com/embed/#{ youtube_id }?wmode=transparent' 
        frameborder='0' 
        allowfullscreen>
      </iframe>
      eos
      .html_safe
    end
  end
end