# frozen_string_literal: true

module ApplicationHelper
  # ユーザーのアイコン画像を表示するメソッド
  # user: 対象のユーザー, size: 画像サイズ（デフォルトは40px）
  def user_avatar(user, size: 40)
    if user.avatar.attached?
      # 画像があればそれを表示
      image_tag user.avatar.variant(resize_to_fill: [size, size]), class: 'rounded-full object-cover', style: "width: #{size}px; height: #{size}px;"
    else
      # なければダミー画像（グレーの丸）を表示
      # ネット上のフリー素材URLなどを使ってもOKですが、今回はCSSで丸を作る
      content_tag :div, '', class: 'bg-gray-400 rounded-full', style: "width: #{size}px; height: #{size}px;"
    end
  end

  # ページごとの完全なタイトルを返す
  def page_title(page_title = '')
    base_title = "Rails Review App"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # デフォルトのメタタグ設定
  def default_meta_tags
    {
      site: 'Rails Review App',
      title: '学習用SNSアプリ',
      reverse: true, # "ページ名 | サイト名" の順にする
      charset: 'utf-8',
      description: 'Rails 8とHotwireを使って作成した、学習用のアウトプットアプリです。',
      keywords: 'Rails,Ruby,プログラミング,学習',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp_sample.png'), # 配置する画像（後述）
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image', # 大きな画像で表示
        # site: '@ツイッターのアカウント名', # あれば設定
      }
    }
  end
end
