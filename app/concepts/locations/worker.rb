module Locations
  class Worker
    include Sidekiq::Worker

    def perform(worker_class, params)
      worker_class.constantize.new(params).call
    end
  end
end
