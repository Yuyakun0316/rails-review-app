# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    # Turbo Stream用のレスポンス（暗黙的に create.turbo_stream.erb を探す）
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    # Turbo Stream用のレスポンス
  end
end
