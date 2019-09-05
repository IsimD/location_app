module API
  module V1
    class Locations < Grape::API
      include API::V1::Defaults

      resources :locations do
        desc "Check location"
        params do
          requires :id, type: Integer
        end
        get "/:id" do
          ::Locations::UseCases::CheckLocation.call(user: current_user, id: params[:id])
        rescue ::Locations::UseCases::CheckLocation::CheckLocationError => e
          status 422
          { message: e.message }
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
