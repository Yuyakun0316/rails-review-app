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

  private # ここから下は「このクラスの中でしか使えない」という意味（Ruby基礎！）

  # ストロングパラメーター（セキュリティ）
  # フォームから送られてきたデータの中から、content だけを許可する
  def post_params
    params.require(:post).permit(:content)
  end
end