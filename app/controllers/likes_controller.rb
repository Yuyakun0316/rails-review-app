# frozen_string_literal: true

class LikesController < ApplicationController
  # 投稿を探して変数に入れる（共通処理）
  before_action :set_post

  def create
    # いいねを作成
    current_user.likes.create(post_id: @post.id)

    # Turbo Streamでレスポンス（後述の create.turbo_stream.erb を探してくれる）
  end

  def destroy
    # いいねを探して削除
    like = current_user.likes.find_by(post_id: @post.id)
    like.destroy

    # Turbo Streamでレスポンス
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
