
module Goodnight::V202509
  class Users < ::Goodnight::ApplicationAPI
    resources :users do
      desc 'Show current logged-in users',
           success: [
             { code: 200, model: Entities::User }
           ]

      get 'current' do
        authenticate!
        present current_user, with: Entities::User
      end
    end
  end
end
