# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :string(255)
#  status     :integer          default("published"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user

  # contentカラムには、値が存在（presence）していないとダメ！
  validates :content, presence: true

  # 「投稿は複数のコメントを持つ（削除されたらコメントも道連れにする）」
  has_many :comments, dependent: :destroy
  # 投稿はたくさんのいいねを持つ
  has_many :likes, dependent: :destroy
  # :image という名前でファイルにアクセスできるようになります
  has_one_attached :image

  has_many :notifications, dependent: :destroy

  # 通知を作成するメソッド
  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索（連打された時に通知が何個も行かないように）
    temp = Notification.where(['visitor_id = ? and visited_id = ? and post_id = ? and action = ? ', current_user.id, user_id, id, 'like'])

    # 通知がまだ存在しない場合のみ作成
    return if temp.present?

    notification = current_user.active_notifications.new(
      post_id: id,
      visited_id: user_id,
      action: 'like'
    )

    # 自分の投稿にいいねした場合は、最初から「既読」にしておく（通知しなくていい）
    notification.checked = true if notification.visitor_id == notification.visited_id

    notification.save if notification.valid?
  end

  # content（本文）と created_at（日時）での検索を許可する
  def self.ransackable_attributes(_auth_object = nil)
    %w[content created_at]
  end

  # 関連するテーブル（Userなど）での検索を許可する場合
  def self.ransackable_associations(_auth_object = nil)
    ['user']
  end

  # 「特定のユーザーたちが書いた投稿」だけを取り出す便利メソッド（scope）
  # Post.where(user_id: [1, 2, 3]) みたいなSQLを簡単に作れるようにします
  scope :by_users, ->(user_ids) { where(user_id: user_ids) }

  # 0: published (公開), 1: draft (下書き)
  enum :status, { published: 0, draft: 1 }

  # バリデーションの調整（もしあれば）
  # 下書きのときは中身が空でもいい、などのルール変更もできますが、今回はそのままでOK
end
