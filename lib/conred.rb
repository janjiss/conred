require "conred/version"
require "action_view"
require "conred/helpers"
require "conred/video"
require "conred/links"
require "haml"
module Conred
  def self.render_file(filename)
    contents = File.read(filename)
    Haml::Engine.new(contents).render
  end
end