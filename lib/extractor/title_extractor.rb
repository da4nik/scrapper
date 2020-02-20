# frozen_string_literal: true

class Extractor
  # TitleExtractor extracts title tag contents of html document
  class TitleExtractor
    def initialize(_opts = {}) end

    def extract(html)
      doc = Nokogiri::HTML(html)
      # For simplicity
      return nil if doc.errors.any?

      node = doc.at_css('title')
      return nil if node.nil?

      node.text
    end
  end
end
