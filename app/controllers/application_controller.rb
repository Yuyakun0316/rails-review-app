# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Deviseのコントローラーが動く時だけ、このメソッドを実行する
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # アカウント登録時（sign_up）と、プロフィール変更時（account_update）に
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :postal_code, :address])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar, :postal_code, :address])
  end
end
