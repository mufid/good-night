require 'rails_helper'

RSpec.describe Goodnight::V202509::Sleeps, type: :request do
  let(:user) { create(:user) }
  let(:user_to_follow) { create(:user) }
  let(:user_to_unfollow) { create(:user) }
  let(:headers) { { 'Authorization' => basic_auth_header(user) } }
  describe 'POST /api/2025-09/users/:id/follow' do
    context 'if not followed yet' do
      it 'successfully followed' do
        expect(user.reload.followings.count).to eq 0
        post "/api/2025-09/users/#{user_to_follow.id}/follow", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response).to have_json_path('message').with_value('User followed successfully')
        expect(user.reload.followings.count).to eq 1
      end
    end

    context 'if already followed' do
      it 'responded with 422' do
        UserFollowing.create(user_id: user.id, user_following_id: user_to_follow.id)
        expect(user.reload.followings.count).to eq 1
        post "/api/2025-09/users/#{user_to_follow.id}/follow", headers: headers

        expect(response).to have_http_status(422)
        expect(response).to have_json_path('invalids', 0).with_value('This user is already followed')
        expect(user.reload.followings.count).to eq 1
      end
    end
  end

  describe 'POST /api/2025-09/users/:id/follow' do
    context 'if previously followed' do
      it 'successfully unfollowed' do
        UserFollowing.create(user_id: user.id, user_following_id: user_to_unfollow.id)
        expect(user.reload.followings.count).to eq 1
        post "/api/2025-09/users/#{user_to_unfollow.id}/unfollow", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response).to have_json_path('message').with_value('User unfollowed successfully')
        expect(user.reload.followings.count).to eq 0
      end
    end

    context 'if already followed' do
      it 'responded with 422' do
        UserFollowing.create(user_id: user.id, user_following_id: user_to_follow.id)
        expect(user.followings.count).to eq 1
        post "/api/2025-09/users/#{user_to_unfollow.id}/unfollow", headers: headers

        expect(response).to have_http_status(422)
        expect(response).to have_json_path('invalids', 0).with_value('Already unfollowed or never follows this user')
        expect(user.reload.followings.count).to eq 1
      end
    end
  end

end
