# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class Scrapper
  def initialize(extractor, store, opts = {})
    @thread_count = opts[:thread_count] || 4
    @store = store
    @extractor = extractor
    @queue = Queue.new
  end

  def process(urls)
    return unless urls.is_a?(Array)

    urls.compact.each { |url| @queue << url }
  end

  def run
    @thread_count.times do
      Thread.new { consumer }
    end
  end

  def stop
    @thread_count.times { @queue << nil }
  end

  private

  def consumer
    loop do
      url = @queue.pop
      break if url.nil?

      html = nil
      begin
        html = open url
      rescue StandardError => e
        @store.save(url: url, status: "fetch error: #{e.message}")
        next
      end

      data = @extractor.extract(html)

      @store.save({
                    url: url,
                    status: html.status.join(','),
                    title: data
                  })
    end
  end
end
