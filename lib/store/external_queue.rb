# frozen_string_literal: true

require 'sequel'

class Store
  class ExternalQueue
    def initialize(_opts = {})
      # External queue, kinda :)
      @queue = Queue.new
    end

    def save(entity)
      @queue << entity
    end
  end
end
