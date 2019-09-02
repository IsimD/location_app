module Locations
  class Worker
    include Sidekiq::Worker

    def perform(_params)
      ::LocationAreas::UseCases::Create.new.call
    end
  end
end
