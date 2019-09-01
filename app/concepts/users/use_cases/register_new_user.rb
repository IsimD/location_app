module Users
  module UseCases
    class RegisterNewUser
      def self.call
        new.call
      end

      def initialize
        @auth_token = generate_auth_token
      end

      def call
        create_user
      end

      private

      def create_user
        Users::Repository::Commands.create_user(auth_token: @auth_token)
      end

      def generate_auth_token
        SecureRandom.hex
      end
    end
  end
end
