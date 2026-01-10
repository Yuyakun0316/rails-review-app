# 1. 既存のデータを全て消す（重複を防ぐため）
puts "古いデータを削除中..."
User.destroy_all
# 投稿やいいねはUserに紐付いているので、Userを消せば連動して全部消えます

puts "新しいデータを作成中..."

puts "管理者ユーザーを作成中..."
User.create!(
  email: "admin@gmail.com",
  password: "password",
  password_confirmation: "password",
  admin: true  # 管理者フラグをONにする
)

# 2. ログイン用の「テストユーザー」を1人作る
# これを作っておけば、毎回「新規登録」しなくてもすぐにログインできます
main_user = User.create!(
  email: "test@gmail.com",
  password: "Test1234",
  password_confirmation: "Test1234"
)

# 3. その他のランダムなユーザーを10人作る
10.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password"
  )

  # 4. 各ユーザーに「投稿」を3件ずつさせる
  3.times do
    user.posts.create!(
      content: Faker::Lorem.sentence(word_count: 5) # 適当な文章
    )
  end
end

puts "データ投入完了！"
puts "---------------------------------"
puts "管理者: admin@gmail.com / password"
puts "一般: test@gmail.com / Test1234"
puts "---------------------------------"