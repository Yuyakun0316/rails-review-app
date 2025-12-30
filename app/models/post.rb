# frozen_string_literal: true

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
end
