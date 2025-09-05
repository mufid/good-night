require 'rails_helper'

RSpec.describe Goodnight::V202509::Sleeps, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => basic_auth_header(user) } }
  describe 'GET /api/2025-09/sleeps/clock_in' do
    context 'with no sleep session' do
      it 'increases sleep session count' do
        expect {
          post '/api/2025-09/sleeps/clock_in', headers: headers
        }.to change(Sleep, :count).by(1)
      end

      it 'correctly recorded sleep session' do
        post '/api/2025-09/sleeps/clock_in', headers: headers
        expect(response).to have_http_status(:created)
        sleep = Sleep.find(JSON.parse(response.body)['id'])

        expect(sleep.clocked_in_at).to be_within(5.seconds).of(Time.zone.now)
        expect(sleep.duration_minutes).to eq(0)
      end

      it 'wont save when there is existing sleep session' do
        expect(Sleep.count).to eq(0)

        post '/api/2025-09/sleeps/clock_in', headers: headers
        expect(response).to have_http_status(:created)
        expect(Sleep.count).to eq(1)

        post '/api/2025-09/sleeps/clock_in', headers: headers
        expect(response).to have_http_status(422)
        expect(Sleep.count).to eq(1)
      end
    end
  end

  describe 'GET /api/2025-09/sleeps/current' do
    context 'with no sleep session' do
      it 'responded with 404' do
        get '/api/2025-09/sleeps/current', headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with sleep session' do
      let!(:sleep) { create(:sleep, :in_progress, user: user) }
      it 'responded with actual sleep session' do
        get '/api/2025-09/sleeps/current', headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to have_json_path('id').with_value(sleep.id)
      end
    end
  end
  
end
