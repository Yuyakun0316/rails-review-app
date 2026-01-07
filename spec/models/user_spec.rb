# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  postal_code            :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
