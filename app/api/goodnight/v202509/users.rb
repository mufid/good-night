
module Goodnight::V202509
  class Users < ::Goodnight::ApplicationAPI
    resources :users do
      get 'current' do
        authenticate!
        present current_user, with: Entities::User
      end
    end
  end
end
