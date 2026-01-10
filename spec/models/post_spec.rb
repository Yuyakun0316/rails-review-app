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
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '投稿の保存' do
    # 正常系
    it 'テキストがあり、ユーザーと紐付いていれば保存できる' do
      post = FactoryBot.build(:post)
      expect(post).to be_valid
    end

    # 異常系
    it 'テキストが空だと保存できない' do
      post = FactoryBot.build(:post, content: '')
      expect(post).not_to be_valid
    end

    it 'ユーザーが紐付いていないと保存できない' do
      post = FactoryBot.build(:post, user: nil)
      expect(post).not_to be_valid
    end
  end
end
