RailsAdmin.config do |config|
  ### Popular gems integration

  # 1. 認証（ログインしているか？）
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  # 2. 認可（管理者権限があるか？）
  config.current_user_method(&:current_user)

  # ★これを追加！「JSもCSSもSprocketsを使うよ」という宣言
  config.asset_source = :sprockets

  # ★これを追加！
  # 「adminフラグがtrueじゃないユーザーは、トップページに追い返す」
  config.authorize_with do
    unless current_user.admin?
      redirect_to main_app.root_path, alert: "管理者としてログインしていません。"
    end
  end

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
