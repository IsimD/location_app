module API
  module V1
    class Areas < Grape::API
      include API::V1::Defaults

      resources :areas do
        desc "Return current areas"
        get "" do
          areas = ::Areas::Repository::Queries.new(user: current_user).find_user_areas
          areas.map { |area| ::Areas::Representers::Basic.call(area: area) }
        end

        desc "Create new area"
        params do
          requires :type, type: String
          requires :features, type: JSON do
            requires :type
            requires :geometry
          end
        end
        post do
          ::Areas::UseCases::Create.call(params: params, user: current_user)
          { message: "success" }
        rescue ::Areas::Validators::Coordinates::InvalidParamsError => e
          status 422
          { message: e.message }
        end
      end
    end
  end
end
