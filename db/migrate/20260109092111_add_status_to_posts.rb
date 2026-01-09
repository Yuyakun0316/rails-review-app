class AddStatusToPosts < ActiveRecord::Migration[7.0]
  def change
    # default: 0 を追加（指定がなければ 0=公開中 として扱う）
    add_column :posts, :status, :integer, default: 0, null: false
  end
end
