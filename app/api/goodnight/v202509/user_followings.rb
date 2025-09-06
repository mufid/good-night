
module Goodnight::V202509
  class UserFollowings < ::Goodnight::ApplicationAPI
    resources :users do
      route_param :id do

        post :follow do
          authenticate!
          user_to_follow = User.find(params[:id])
          record = ::UserFollowings::Follow.new(current_user:, user_to_follow:)
          return failure_with_data(record) if !record.save

          status :ok
          { message: 'User followed successfully' }
        end
        post :unfollow do
          authenticate!
          user_to_unfollow = User.find(params[:id])

          record = ::UserFollowings::Unfollow.new(current_user:, user_to_unfollow:)
          return failure_with_data(record) if !record.save

          status :ok
          { message: 'User unfollowed successfully' }
        end

      end

      params do
        optional :after, type: Integer
      end
      get :followings do
        authenticate!
        users = UserFollowing.includes(:user_following).where(user_id: current_user.id).after(params[:after])
        present CursorArray.new(users), with: Entities::WithCursor, entry: Entities::Following
      end

      params do
        optional :after, type: Integer
      end
      get :followers do
        authenticate!
        users = UserFollowing.includes(:user_following).where(user_following_id: current_user.id).after(params[:after])
        present CursorArray.new(users), with: Entities::WithCursor, entry: Entities::Follower
      end
    end

  end
end
