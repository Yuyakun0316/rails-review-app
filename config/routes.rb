Rails.application.routes.draw do
  get "notifications/index"
  # 1. トップページの設定
  root 'posts#index'

  # 2. ユーザー認証（Devise）
  devise_for :users
  
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
end