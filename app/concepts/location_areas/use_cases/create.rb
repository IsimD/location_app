module LocationAreas
  module UseCases
    class Create
      def call
        # TODO mock for test env
        LocationArea.create(name: Time.now)
      end
    end
  end
end
