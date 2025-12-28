# frozen_string_literal: true

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
