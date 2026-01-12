# frozen_string_literal: true

# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  # belongs_to :post
  # 変更後: counter_cache: true を追加！
  # これだけで、いいね作成時に posts.likes_count が +1 され、削除時に -1 されます
  belongs_to :post, counter_cache: true

  # 【重要】user_id と post_id の組み合わせは一意（ユニーク）であること
  # つまり、同じ投稿に2回いいねはできない！
  validates :user_id, uniqueness: { scope: :post_id }
end
