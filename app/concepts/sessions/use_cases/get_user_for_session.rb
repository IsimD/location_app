module Sessions
  module UseCases
    class GetUserForSession
      WrongTokenType = Class.new(StandardError)
      CannotAuthenticateUser = Class.new(StandardError)
      def self.call(headers:)
        new(headers).call
      end

      def initialize(headers)
        @headers = headers
      end

      def call
        if should_check_authorization?
          authenticate_user
        else
          get_default_user
        end
      end

      private

      def should_check_authorization?
        @headers["Authorization"].present?
      end

      def authenticate_user
        user = find_user
        raise CannotAuthenticateUser unless user

        user
      end

      def find_user
        token = get_token
        ::Sessions::Repository::Queries.find_user_by_token(auth_token: token)
      end

      def get_default_user
        find_default_user || create_default_user
      end

      def find_default_user
        ::Sessions::Repository::Queries.find_default_user
      end

      def create_default_user
        token = generate_token
        ::Sessions::Repository::Commands.create_default_user(token: token)
      end

      def generate_token
        SecureRandom.hex
      end

      def get_token
        raise WrongTokenType unless @headers["Authorization"].split.first == "Bearer"

        @headers["Authorization"].split.second
      end
    end
  end
end
