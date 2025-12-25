class User < ApplicationRecord
  # Deviseの設定などはそのままで、以下を追加
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # ユーザーが削除されたら、その人の投稿も一緒に消す
  has_many :posts, dependent: :destroy
end
