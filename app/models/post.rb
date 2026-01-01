# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :string(255)
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

  # content（本文）と created_at（日時）での検索を許可する
  def self.ransackable_attributes(_auth_object = nil)
    %w[content created_at]
  end

  # 関連するテーブル（Userなど）での検索を許可する場合
  def self.ransackable_associations(_auth_object = nil)
    ['user']
  end
end
