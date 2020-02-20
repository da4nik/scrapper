# frozen_string_literal: true

require 'sequel'

class Store
  class SQLite
    def initialize(opts = {})
      @db_filename = opts[:db]
      @db = if @db_filename.nil?
              Sequel.sqlite
            else
              Sequel.connect("sqlite://#{@db_filename}")
            end

      init_db
    end

    def save(entity)
      urls = @db[:urls]
      urls.insert entity
    end

    def count
      urls = @db[:urls]
      urls.count
    end

    private

    def init_db
      return if @db.table_exists?(:urls)

      @db.create_table :urls do
        primary_key :id
        String :url
        String :status
        String :title
      end
    end
  end
end
