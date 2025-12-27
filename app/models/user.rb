class User < ApplicationRecord
  # Deviseの設定などはそのままで、以下を追加
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # ユーザーが削除されたら、その人の投稿も一緒に消す
  has_many :posts, dependent: :destroy
  # ユーザーはたくさんのいいねを持つ
  has_many :likes, dependent: :destroy
  
  # おまけメソッド（Viewで使うと便利！）
  # 「このユーザーは、この投稿にいいねしてる？」を判定するメソッド
  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end
end
