require 'rails_helper'

RSpec.describe User, type: :model do
  # 「ユーザー登録機能」についてのテスト
  describe 'ユーザー登録' do
    
    # 1. 正常系（成功するパターン）
    it "メールアドレスとパスワードがあれば登録できる" do
      # 1. ユーザーのデータを作る
      user = User.new(
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      )
      
      # 2. そのユーザーが「valid（有効）」であることを期待する
      expect(user).to be_valid
    end

    # 2. 異常系（失敗するパターン）
    it "メールアドレスがないと登録できない" do
      # emailを空っぽにする
      user = User.new(
        email: "",
        password: "password123",
        password_confirmation: "password123"
      )
      
      # 3. バリデーションに引っかかる（validではない）ことを期待する
      expect(user).to_not be_valid
    end
  end
end
