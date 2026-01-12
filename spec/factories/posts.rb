# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  content     :string(255)
#  likes_count :integer          default(0), not null
#  status      :integer          default("published"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    content { 'テスト投稿です' }
    association :user # 重要！「投稿を作るなら、親であるユーザーも自動で作ってね」という命令
  end
end
