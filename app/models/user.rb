# frozen_string_literal: true

class User < ApplicationRecord
  # Deviseの設定などはそのままで、以下を追加
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザーが削除されたら、その人の投稿も一緒に消す
  has_many :posts, dependent: :destroy
  # ユーザーはたくさんのいいねを持つ
  has_many :likes, dependent: :destroy

  has_one_attached :avatar

  # 「likesテーブルを経由して、postデータ（liked_posts）を取得する」という命令
  has_many :liked_posts, through: :likes, source: :post

  # 1. 自分がフォローしている人たち（active_relationships）
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  # 2. 自分をフォローしている人たち（passive_relationships）
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # --- ヘルパーメソッド（便利機能） ---

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # フォローを外す
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # フォローしているか確認する
  def following?(other_user)
    following.include?(other_user)
  end

  # おまけメソッド（Viewで使うと便利！）
  # 「このユーザーは、この投稿にいいねしてる？」を判定するメソッド
  def already_liked?(post)
    likes.exists?(post_id: post.id)
  end
end
