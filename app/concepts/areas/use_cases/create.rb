module Areas
  module UseCases
    class Create
      def self.call(params:, user:)
        new(user, params).call
      end

      def initialize(user, params)
        @params = params
        @user = user
      end

      def call
        validate_params
        ActiveRecord::Base.transaction do
          delete_old_areas
          create_areas
        end
      end

      attr_reader :params, :user

      private

      def validate_params
        params["features"].each do |param|
          ::Areas::Validators::Coordinates.new(param).call
        end
      end

      def prepare_coords_param
        params["features"].map { |param| param["geometry"]["coordinates"] }
      end

      def delete_old_areas
        ::Areas::Repository::Commands.new(user: user).destroy_all_areas
      end

      def create_areas
        prepare_coords_param.each do |coordinates|
          ::Areas::Repository::Commands.new(user: user).create_new_area(
            coordinates: coordinates,
          )
        end
      end
    end
  end
end
