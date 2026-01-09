# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    # 1. URLのIDからユーザーを探す
    @user = User.find(params[:id])

    # もし「ログイン中のユーザー」が「このページの本人」なら、全部（下書き含む）見せる
    if current_user == @user
      @posts = @user.posts.with_attached_image.order(created_at: :desc).page(params[:page]).per(5)
    else
      # 他人のページなら、公開されているもの（published）だけ見せる
      @posts = @user.posts.published.with_attached_image.order(created_at: :desc).page(params[:page]).per(5)
    end
  end

  def likes
    # 1. ユーザーを探す
    @user = User.find(params[:id])

    # 2. そのユーザーが「いいねした投稿」を取得
    # N+1対策（includes）も忘れずに！
    @posts = @user.liked_posts.includes(:user).with_attached_image.order(created_at: :desc).page(params[:page]).per(5)
  end
end
