# frozen_string_literal: true

require_relative 'store/sqlite'

# Stores some data in somewhere
class Store
  def initialize(adapter, opts = {})
    @adapter = case adapter
               when :sqlite then Store::SQLite.new(opts)
               when :external_queue then Store::ExternalQueue.new
               else
                 raise 'Adapter not supported'
               end
  end

  def save(entity)
    @adapter.save(entity)
  end
end
