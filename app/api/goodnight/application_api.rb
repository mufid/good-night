module Goodnight
  class ApplicationAPI < Grape::API
    format :json

    helpers do
      def current_user
        return @current_user if @current_user

        authorization = request.headers['Authorization']
        return nil if authorization.blank?

        _, bearer, _ = authorization.split
        return nil if bearer.blank?

        user_id, _ = ::Base64.decode64(bearer).split(':').map(&:to_i)
        @current_user = User.find_by(id: user_id)
      end

      def authenticate!
        error!('Unathorized or user doesnt exist', 401) if current_user.nil?
      end
      def to_be_implemented!
        error!('Not yet implemented', 405)
      end

      def failure_with_data(model)
        status 422
        {
          error: 'Invalid data',
          invalids: model.errors.to_a
        }
      end
    end
  end
end
