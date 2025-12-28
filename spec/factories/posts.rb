# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    content { 'テスト投稿です' }
    association :user # 重要！「投稿を作るなら、親であるユーザーも自動で作ってね」という命令
  end
end
