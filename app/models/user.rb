# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  postal_code            :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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

  # 1. 自分「が」送った通知（active_notifications）
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy

  # 2. 自分「に」届いた通知（passive_notifications）
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # データ作成後にメソッドを呼ぶ
  after_create :send_welcome_email

  # 3. 未読の通知があるか確認するメソッド（後でヘッダーで使います！）
  def unchecked_notifications?
    passive_notifications.where(checked: false).any?
  end

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

  # ゲストユーザーを探す、なければ作るメソッド
  def self.guest
    # find_or_create_by! は「探して、なければ作る」という超便利メソッド
    find_or_create_by!(email: 'guest@example.com') do |user|
      # パスワードはランダムな文字列にする（誰も推測できないように）
      user.password = SecureRandom.urlsafe_base64
      # もし名前など必須項目があればここに追加（user.name = "ゲスト" など）
    end
  end

  private
  
  def send_welcome_email
    # メイラーを呼び出して、deliver_now（今すぐ送る）
    UserMailer.welcome_email(self).deliver_now
  end
end
