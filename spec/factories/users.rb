# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email } # Fakerを使ってランダムなメアドを生成！
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
