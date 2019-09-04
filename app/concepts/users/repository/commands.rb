module Users
  module Repository
    class Commands
      class << self
        def create_user(auth_token:)
          User.create!(auth_token: auth_token)
        end
      end
    end
  end
end
