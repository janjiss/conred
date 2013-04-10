require "conred/version"
require "action_view"
require "net/http"
module Conred
  module Video
    def initialize(arguments = {:width => 670, :height => 450, :error_message => "Video url you have provided is invalid"})
      @width = arguments[:width]
      @height = arguments[:height]
      @error_message = arguments[:error_message]
      @video_id = get_video_id_from arguments[:video_url]
    end

    def youtube_video?
      is_a?(Video::Youtube)
    end

    def vimeo_video?
      is_a?(Video::Vimeo)
    end

    def code
      render(
        :video_link => video_link,
        :height => @height,
        :width => @width
      ).html_safe
    end

    def exist?
      response = Net::HTTP.get_response(URI(api_uri))
      response.is_a?(Net::HTTPSuccess)
    end

    private

    def render(locals = {})
      path = File.join(
        File.dirname(__FILE__),
        "../views/video/video_iframe".split("/")
      )
      Haml::Engine.new(File.read("#{path}.html.haml")).render(Object.new, locals)
    end

    class Youtube
      include Video

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

    class Vimeo
      include Video

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
        video_id = $1
      end
    end

    class Other
      include Video
      def initialize(arguments = {:error_message => "Video url you have provided is invalid"})
        @error_message = arguments[:error_message]
      end

      def code
        @error_message
      end
    end
  end
end
