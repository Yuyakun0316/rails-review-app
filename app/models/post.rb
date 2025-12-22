class Post < ApplicationRecord
  # contentカラムには、値が存在（presence）していないとダメ！
  validates :content, presence: true
end
