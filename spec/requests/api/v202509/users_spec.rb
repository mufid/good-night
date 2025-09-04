require 'rails_helper'

RSpec.describe Goodnight::V202509::Users, type: :request do
  describe 'GET /api/v2025-09/users/current' do
    context 'user exists' do
      let(:users) { create_list(:user, 30) }
      let(:user) { users.last }
      let(:headers) { { 'Authorization' => basic_auth_header(user) } }
      it 'returns current user' do
        get '/api/2025-09/users/current', headers: headers
        expect(response).to have_json_path('id').with_value(user.id)
      end
    end

    context 'user doesnt exist' do
      let(:headers) { { 'Authorization' => basic_auth_header(123) } }
      it 'returns unauthorized' do
        get '/api/2025-09/users/current', headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
