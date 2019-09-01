module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      resources :users do
        desc "Register new user"
        post "registrations" do
          user = ::Users::UseCases::RegisterNewUser.call
          ::Users::Representers::Basic.call(user: user)
        end

        get "me" do
          ::Users::Representers::Basic.call(user: current_user)
        end
      end
    end
  end
end
