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
    end
  end
end
