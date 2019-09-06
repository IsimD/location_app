module Areas
  module Repository
    class Queries
      def initialize(user:)
        @user = user
      end

      attr_reader :user

      def find_user_areas
        user.areas
      end
    end
  end
end
