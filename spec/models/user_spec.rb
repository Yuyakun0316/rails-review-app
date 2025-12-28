# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録' do
    # 1. 正常系
    it 'メールアドレスとパスワードがあれば登録できる' do
      # FactoryBot.build(:user) で、さっき定義したデータを一発で作れる！
      user = FactoryBot.build(:user)

      expect(user).to be_valid
    end

    # 2. 異常系
    it 'メールアドレスがないと登録できない' do
      # emailだけ上書きして空にする、という使い方もできる！
      user = FactoryBot.build(:user, email: '')

      expect(user).not_to be_valid
    end
  end
end
