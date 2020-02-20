# frozen_string_literal: true

require_relative 'scrapper'
require_relative 'store'
require_relative 'extractor/title_extractor'
require 'sinatra'
require 'psych'

class App < Sinatra::Base
  configure do
    config = Psych.load(File.read('scrapper.yml'), symbolize_names: true)

    store = Store.new(:sqlite, db: config[:db])
    extractor = Extractor::TitleExtractor.new
    scrapper = Scrapper.new(extractor,
                            store,
                            thread_count: config[:thread_count])
    scrapper.run

    set :scrapper, scrapper
    set :port, config[:port]
    set :logging, true
    set :app_file, __FILE__
  end

  before do
    headers 'Content-Type' => 'application/json'

    request.body.rewind
    begin
      @parsed_body = Psych.load(request.body.read, symbolize_names: true)
    rescue StandardError => e
      halt 400, { error: e.message }.to_json
    end
  end

  post '/urls' do
    unless @parsed_body.is_a?(Array)
      halt 400, { error: 'This call requires array of urls' }.to_json
    end

    settings.scrapper.process @parsed_body

    status :ok
  end
end
