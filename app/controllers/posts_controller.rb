class PostsController < ApplicationController
  def index
    # 新しい投稿を作るための「空っぽのインスタンス」を用意
    # フォーム（form_with）で使うために必要！
    @post = Post.new
    @posts = Post.all
  end

  # フォームから送られてきた時のアクション
  def create
    # フォームのデータを受け取って保存
    Post.create(post_params)
    
    # トップページに戻る（リダイレクト）
    redirect_to root_path
  end

  # --- ここから追加 ---

  # 編集画面を表示するアクション
  def edit
    # URLの「/posts/1/edit」の「1」を params[:id] で受け取る
    # find(番号) で、そのIDのデータをデータベースから探してくる
    @post = Post.find(params[:id])
  end

  # 更新ボタンが押された時のアクション
  def update
    # 編集画面で表示しているデータをもう一度探す
    post = Post.find(params[:id])
    
    # データの中身を書き換えて保存（update）
    post.update(post_params)
    
    # トップページに戻る
    redirect_to root_path
  end
  
  # --- ここまで ---

  private # ここから下は「このクラスの中でしか使えない」という意味（Ruby基礎！）

  # ストロングパラメーター（セキュリティ）
  # フォームから送られてきたデータの中から、content だけを許可する
  def post_params
    params.require(:post).permit(:content)
  end
end