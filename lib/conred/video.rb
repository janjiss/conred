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
      selected_strategy = available_strategies.select { |strategy| strategy.url_format_is_valid?(arguments[:video_url])}.first
      selected_strategy.new arguments
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
      response = Net::HTTP.get_response(URI("http:#{api_uri}"))
      response.is_a?(Net::HTTPSuccess)
    end

    attr_reader :height, :width, :video_id, :error_message

  end
end
