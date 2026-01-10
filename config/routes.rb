Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get "notifications/index"
  # 1. トップページの設定
  root 'posts#index'

  # 2. ユーザー認証（Devise）
  # 変更前
  # devise_for :users

  # 変更後：ここを書き換え！
  # 1. sessionsコントローラーは、さっき作った 'users/sessions' を使うよ、という設定
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # 2. ゲストログイン用のURLを作る
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  
  # 3. ユーザー関連（マイページ、フォロー、いいね一覧）
  resources :users, only: [:show] do
    # いいね一覧 (/users/:id/likes)
    get :likes, on: :member
    # フォロー機能
    resource :relationships, only: [:create, :destroy]
  end

  # 4. 投稿関連（CRUD、コメント、いいね）
  resources :posts do
    resources :comments, only: [:create]
    resource :likes, only: [:create, :destroy]
  end

  resources :notifications, only: :index

  # 5. ヘルスチェック（Rails 7/8標準）
  get 'up' => 'rails/health#show', as: :rails_health_check

  # 開発環境（development）の時だけ、メール確認ページを表示する
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end