module Sessions
  module Repository
    class Queries
      class << self
        def find_default_user
          User.where(default_user: true).first
        end

        def find_user_by_token(auth_token:)
          User.find_by(auth_token: auth_token)
        end
      end
    end
  end
end
