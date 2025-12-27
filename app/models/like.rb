class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 【重要】user_id と post_id の組み合わせは一意（ユニーク）であること
  # つまり、同じ投稿に2回いいねはできない！
  validates :user_id, uniqueness: { scope: :post_id }
end