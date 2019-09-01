module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json

        helpers do
          def permitted_params
            @permitted_params ||= declared(params,
                                           include_missing: false)
          end

          def logger
            Rails.logger
          end

          def current_user
            @current_user ||= ::Sessions::UseCases::GetUserForSession.call(headers: headers)
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: e.message, status: 422)
        end

        rescue_from ::Sessions::UseCases::GetUserForSession::WrongTokenType do
          error_response(
            message: "Wrong token type, please check supported token types in the documentation",
            status: 422,
          )
        end

        rescue_from ::Sessions::UseCases::GetUserForSession::CannotAuthenticateUser do
          error_response(
            message: "We cannot find your user, please check your token",
            status: 422,
          )
        end
      end
    end
  end
end
