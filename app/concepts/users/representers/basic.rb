module Users
  module Representers
    class Basic
      class << self
        def call(user:)
          {
            id: user.id,
            auth_token: user.auth_token,
          }
        end
      end
    end
  end
end
