require "conred/version"
require "action_view"

module Conred

  class Helpers
    def self.sanitize_and_trim(text, word_count = nil, omission = '...')
      action_view = ActionView::Base.new
      text = action_view.strip_tags(text)
      if word_count
        action_view.truncate(text, :length => word_count, :omission => omission)
      else
        text
      end
    end
  end

  class Video
    attr_reader :code

    def initialize(video_url)
      @video_url = video_url
      if youtube_video?
        @code = video_from_youtube_url(video_url)
      elsif vimeo_video?
        @code = video_from_vimeo_url(video_url)
      else
        ""
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


    def video_from_vimeo_url(vimeo_url, width = 670, height = 450)
      if vimeo_url[/youtu\.be\/([^\?]*)/]
        vimeo_id = $1
      else
        vimeo_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
        vimeo_id = $5
      end
      "<iframe 
        src='http://player.vimeo.com/video/#{vimeo_id}'
        width='#{width}' 
        height='#{height}'
        frameborder='0'
        webkitAllowFullScreen
        mozallowfullscreen
        allowFullScreen>
      </iframe>"
    end

    def video_from_youtube_url(youtube_url, width = 670, height = 450)
      if youtube_url[/youtu\.be\/([^\?]*)/]
          youtube_id = $1
      else
        youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
        youtube_id = $5
      end
      "<iframe
        id='youtube_video'
        title='YouTube video player' 
        width='#{width}' 
        height='#{height}' 
        src='http://www.youtube.com/embed/#{ youtube_id }' 
        frameborder='0' 
        allowfullscreen>
      </iframe>".html_safe
    end
  end

  class Links

  end
end