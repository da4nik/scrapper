# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../lib/extractor/title_extractor'

RSpec.describe Extractor::TitleExtractor do
  subject { Extractor::TitleExtractor.new }

  describe '.extract' do
    let(:title) { 'Super title' }
    let(:valid_html) { "<html><title>#{title}</title></html>" }

    it 'should return html title' do
      expect(subject.extract(valid_html)).to eq(title)
    end

    it 'should return nil if not correct html' do
      expect(subject.extract('<html>')).to be_nil
    end
  end
end
