# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    # 1. URLのIDからユーザーを探す
    @user = User.find(params[:id])

    # 2. そのユーザーの投稿を全部取得（新しい順）
    # N+1対策で画像も一緒に持ってくる！
    @posts = @user.posts.with_attached_image.order(created_at: :desc).page(params[:page]).per(5)
  end

  def likes
    # 1. ユーザーを探す
    @user = User.find(params[:id])
    
    # 2. そのユーザーが「いいねした投稿」を取得
    # N+1対策（includes）も忘れずに！
    @posts = @user.liked_posts.includes(:user).with_attached_image.order(created_at: :desc).page(params[:page]).per(5)
  end
end
