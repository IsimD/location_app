module LocationAreas
 class Worker
    include Sidekiq::Worker

    def perform(test)
      p test
      ::LocationAreas::UseCases::Create.new.call
    end
  end
end
