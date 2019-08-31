module API
  module V1
    class Locations < Grape::API
      include API::V1::Defaults

      resources :locations do
        desc "Test"
        get do
          { message: "hello" }
        end
      end
    end
  end
end
