module ApplicationHelper
  # ユーザーのアイコン画像を表示するメソッド
  # user: 対象のユーザー, size: 画像サイズ（デフォルトは40px）
  def user_avatar(user, size: 40)
    if user.avatar.attached?
      # 画像があればそれを表示
      image_tag user.avatar.variant(resize_to_fill: [size, size]), class: "rounded-full object-cover", style: "width: #{size}px; height: #{size}px;"
    else
      # なければダミー画像（グレーの丸）を表示
      # ネット上のフリー素材URLなどを使ってもOKですが、今回はCSSで丸を作る
      content_tag :div, "", class: "bg-gray-400 rounded-full", style: "width: #{size}px; height: #{size}px;"
    end
  end
end