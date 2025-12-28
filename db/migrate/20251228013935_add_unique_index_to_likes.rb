class AddUniqueIndexToLikes < ActiveRecord::Migration[8.1]
  def change
    # user_id と post_id の「組み合わせ」が重複しないようにデータベースにロックをかける
    add_index :likes, [:user_id, :post_id], unique: true
  end
end