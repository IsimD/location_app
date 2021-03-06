module API
  module V1
    class Base < Grape::API
      mount API::V1::Areas
      mount API::V1::Locations
      mount API::V1::Users
    end
  end
end
