# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../lib/store/sqlite'

RSpec.describe Store::SQLite do
  let(:sqlite_mem_store) { Store::SQLite.new db: nil }

  describe '.save' do
    it 'should call insert to save record' do
      expect {
        sqlite_mem_store.save(url: 'someurl', status: 'somestatus', title: 'sometitle')
      }.to change { sqlite_mem_store.count }.by(1)
    end
  end

  context 'private' do
    it 'should init db on instanstantiation' do
      expect_any_instance_of(Store::SQLite).to receive(:init_db)
                                              .and_call_original
      sqlite_mem_store
    end
  end
end
