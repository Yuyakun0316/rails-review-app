class PostsController < ApplicationController
  def index
    # Postクラスの allメソッドを使って、全データを配列で取得
    # それをインスタンス変数 @posts に入れる
    @posts = Post.all
  end
end