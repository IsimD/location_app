module Users
  module Repository
    class Commands
      class << self
        def create_user(auth_token:)
          user = User.new(auth_token: auth_token)
          user.save!
          user
        end
      end
    end
  end
end
