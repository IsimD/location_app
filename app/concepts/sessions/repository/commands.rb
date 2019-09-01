module Sessions
  module Repository
    class Commands
      class << self
        def create_default_user(token:)
          User.create(auth_token: token, default_user: true)
        end
      end
    end
  end
end
