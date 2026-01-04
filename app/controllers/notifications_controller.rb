class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 自分宛ての通知（passive_notifications）を取得
    @notifications = current_user.passive_notifications.page(params[:page]).per(10)
    
    # 未読の通知（checked: false）を「既読（true）」にする
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
