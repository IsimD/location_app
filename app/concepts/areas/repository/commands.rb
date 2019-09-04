module Areas
  module Repository
    class Commands
      def initialize(user:)
        @user = user
      end

      attr_reader :user

      def create_new_area(params)
        user.areas.create!(params)
      end

      def destroy_all_areas
        user.areas.destroy_all
      end
    end
  end
end
