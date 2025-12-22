class PostsController < ApplicationController
  def index
    # ここでRubyの「変数」を使う
    
    # 実験1: 普通のローカル変数（@なし）
    title = "これはローカル変数です"

    # 実験2: インスタンス変数（@あり）
    @memo = "これはインスタンス変数です！Viewまで届きます！"
    
    # 実験3: 配列とハッシュ（Ruby基礎でやったやつ！）
    @user_info = { name: "Yuyakun", score: 100 }
  end
end