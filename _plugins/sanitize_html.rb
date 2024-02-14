require 'sanitize'

module Jekyll
  module SanitizeHTML
    def sanitize_html(input)
      Sanitize.fragment(input, Sanitize::Config::RELAXED)
    end
  end
end

Liquid::Template.register_filter(Jekyll::SanitizeHTML)
