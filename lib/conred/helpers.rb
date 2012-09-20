require "conred/version"
require "action_view"

module Conred

  module Helpers
    
    extend self

    def sanitize_and_trim(text, word_count = nil, omission = '...')
      action_view = ActionView::Base.new
      text = action_view.strip_tags(text)
      if word_count
        action_view.truncate(text, :length => word_count, :omission => omission)
      else
        text
      end
    end

    def sanitize_body(text)
      text = sanitize(text, :tags => %w(p a strong ul ol li blockquote strike u em), :attributes => %w(href))
      text.html_safe
    end

  end

end