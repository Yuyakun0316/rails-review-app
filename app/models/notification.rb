# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  action     :string(255)      default(""), not null
#  checked    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :integer
#  post_id    :integer
#  visited_id :integer          not null
#  visitor_id :integer          not null
#
# Indexes
#
#  index_notifications_on_comment_id  (comment_id)
#  index_notifications_on_post_id     (post_id)
#  index_notifications_on_visited_id  (visited_id)
#  index_notifications_on_visitor_id  (visitor_id)
#
class Notification < ApplicationRecord
  # 新しい順に取得するようにデフォルト設定
  default_scope -> { order(created_at: :desc) }

  # user_id ではなく visitor_id 等を使っているので、クラスを明示する
  belongs_to :visitor, class_name: 'User', optional: true
  belongs_to :visited, class_name: 'User', optional: true

  # どの投稿・コメントについての通知か（optional: true は「nilでもOK」という意味）
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
end
