# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get 'posts/index'
  # ユーザー詳細ページへのパス
  # resources :users, only: [:show]
  # 変更後：do ... end でブロックを作る
  resources :users, only: [:show] do
    # /users/:id/likes というURLを作る設定
    get :likes, on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # トップページを postsコントローラーの indexアクションに設定
  root 'posts#index'

  # これを追加：投稿を保存するための通り道（POSTリクエスト）
  # post "posts", to: "posts#create"

  # 【重要】この1行だけで、7つの基本ルート（index, show, new, create, edit, update, destroy）が全部作られます！
  # resources :posts

  # posts のブロックの中に resources :comments を入れる
  resources :posts do
    resources :comments, only: [:create] # 今回は投稿(create)だけでOK
    # resource (単数形) にすると、URLに :id がつかなくなる（/posts/:post_id/like）
    # 「自分のいいね」は1つしか存在しないから単数形でOKという考え方
    resource :likes, only: %i[create destroy] # いいね(create)、いいね(destroy)
  end
end
