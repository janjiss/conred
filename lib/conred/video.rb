require "conred/version"
require "net/http"
require "erb"

module Conred
  module Video
    def initialize(options = {})
      @width         = options.fetch(:width, 670)
      @height        = options.fetch(:height, 450)
      @error_message = options.fetch(:error_message, "Invalid video url")
      @video_id      = get_video_id_from(options[:video_url])
    end

    def self.new(arguments)
      if Youtube.url_format_is_valid? arguments[:video_url]
        Youtube.new arguments
      elsif Video::Vimeo.url_format_is_valid? arguments[:video_url]
        Vimeo.new arguments
      else
        Other.new arguments
      end
    end

    def youtube_video?
      is_a?(Video::Youtube)
    end

    def vimeo_video?
      is_a?(Video::Vimeo)
    end

    def code
      view_path = File.join(
        File.dirname(__FILE__),
        "../views/video/video_iframe.html.erb"
      )
      template = ERB.new(File.read(view_path))
      template.result(binding)
    end

    def exist?
      response = Net::HTTP.get_response(URI("http:#{api_uri}"))
      response.is_a?(Net::HTTPSuccess)
    end

    attr_reader :height, :width, :video_id, :error_message

    private

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
        @video_id = $1
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

      def exist?
        false
      end
    end
  end
end
