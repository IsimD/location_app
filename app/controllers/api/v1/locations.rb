module API
  module V1
    class Locations < Grape::API
      include API::V1::Defaults

      resources :locations do
        desc "Check location"
        get ":id" do
          current_user.locations.find(params[:id])
          { message: "hello" }
        end

        desc "Create new location by name"
        params do
          requires :name, type: String
        end
        post do
          location =
            ::Locations::UseCases::Create.call(user: current_user, params: permitted_params)
          ::Locations::Representers::Minimum.call(location: location)
        end
      end
    end
  end
end
