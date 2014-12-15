require "conred/version"
require "net/http"
require "erb"
require 'active_support/all'

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
      response = Net::HTTP.get_response(URI("http:#{api_uri}"))
      response.is_a?(Net::HTTPSuccess)
    end

    def viewCount
      if self.exist?
        body = Net::HTTP.get_response(URI("http:#{api_uri}")).body

        if self.youtube_video?
          body_json = Hash.from_xml(body).to_json
          body_hash = JSON.parse(body_json)
          viewCount = body_hash["entry"]["statistics"]["viewCount"]
        end

        if self.vimeo_video?
          body_hash = JSON.parse(body)
          viewCount = body_hash.first['stats_number_of_plays']
        end

        return viewCount.to_i unless viewCount.nil?
      end
    end

    attr_reader :height, :width, :video_id, :error_message

  end
end
