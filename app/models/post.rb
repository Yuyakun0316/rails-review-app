class Post < ApplicationRecord
  # contentカラムには、値が存在（presence）していないとダメ！
  validates :content, presence: true

  # これを追加：「投稿は複数のコメントを持つ（削除されたらコメントも道連れにする）」
  has_many :comments, dependent: :destroy
end
