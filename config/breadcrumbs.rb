crumb :root do
  link "トップページ", root_path
end

# マイページ（ユーザー詳細）
crumb :user do |user|
  link "#{user.email} さんのページ", user_path(user)
  parent :root
end

# いいね一覧
crumb :likes do |user|
  link "いいね一覧", likes_user_path(user)
  parent :user, user # 親は「マイページ」
end

# 投稿詳細（もしあれば）
crumb :post do |post|
  link "投稿詳細", post_path(post)
  parent :root
end