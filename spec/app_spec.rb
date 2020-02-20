# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/app'
require_relative '../lib/scrapper'

RSpec.describe App do
  def app
    App
  end

  describe '/urls' do
    describe 'success' do
      let(:url) { 'http://localhost' }
      let(:request) { post '/urls', [url].to_json }

      it 'should return 200 and correct content-type' do
        request
        expect(last_response.status).to eq(200)
        expect(last_response.headers['Content-Type']).to eq('application/json')
      end

      it 'should call process on scrapper' do
        expect_any_instance_of(Scrapper).to receive(:process)
                                            .once
                                            .and_return(true)
        request
        expect(last_response.status).to eq(200)
      end
    end

    describe 'bad requests' do
      it 'should return 400 if not json' do
        post '/urls', 'Hello'
        expect(last_response.status).to eq(400)
      end

      it 'should return 400 if not json is not array' do
        post '/urls', '{"urls": ["http://localhost"]}'
        expect(last_response.status).to eq(400)
      end
    end
  end
end
