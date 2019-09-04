module Locations
  module Repository
    class Commands
      class << self
        def create_location_for_user(user:, name:)
          Location.create!(user: user, name: name)
        end

        def update_location(location:, params:)
          location.update!(params)
        end

        def add_error_to_location(location:, message:)
          location.create_location_error!(message: message)
        end
      end
    end
  end
end
