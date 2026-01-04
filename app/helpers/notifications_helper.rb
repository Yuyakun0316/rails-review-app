# frozen_string_literal: true

module NotificationsHelper
  def notification_form(notification)
    # 通知の送り主（visitor）
    visitor = link_to notification.visitor.email, user_path(notification.visitor), class: 'font-bold hover:underline'

    # 何の通知か判定
    case notification.action
    when 'like'
      # 「〇〇さんが あなたの投稿 にいいねしました」
      post_link = link_to 'あなたの投稿', post_path(notification.post), class: 'font-bold hover:underline text-blue-500'
      "#{visitor}さんが #{post_link} にいいねしました".html_safe
    when 'follow'
      # 「〇〇さんが あなたをフォローしました」
      "#{visitor}さんが あなたをフォローしました".html_safe
    end
  end
end
