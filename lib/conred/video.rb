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
      available_strategies = [YoutubeStrategy,Video::VimeoStrategy,Video::OtherStrategy]
      strategy = available_strategies.select { |strategy| strategy.url_format_is_valid?(arguments[:video_url])}.first
      strategy.new arguments
    end

    def youtube_video?
      is_a?(Video::YoutubeStrategy)
    end

    def vimeo_video?
      is_a?(Video::VimeoStrategy)
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
      response = get_api_response
      response.is_a?(Net::HTTPSuccess)
    end

    def viewCount
      if self.exist?
        body = get_api_response.body

        if self.youtube_video?
          body_json = Hash.from_xml(response.body).to_json
          body_hash = JSON.parse(body_json)
          body_hash["entry"]["statistics"]["viewCount"]
        end

        if self.vimeo_video?
          body_hash = JSON.parse(body)
          body_hash['stats_number_of_plays']
        end
      end
    end

    attr_reader :height, :width, :video_id, :error_message

  end

  private 

  def get_api_response
    Net::HTTP.get_response(URI("http:#{api_uri}"))
  end
end
