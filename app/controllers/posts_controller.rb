class PostsController < ApplicationController
  # アクションが動く「前（before）」に、set_postメソッドを実行せよ！という命令
  # only: [...] で、実行したいアクションだけを指定します
  before_action :set_post, only: [:edit, :update, :destroy]

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

  # 編集画面を表示するアクション
  def edit
    # URLの「/posts/1/edit」の「1」を params[:id] で受け取る
    # find(番号) で、そのIDのデータをデータベースから探してくる
    # @post = Post.find(params[:id])   ← リファクタリング
  end

  # 更新ボタンが押された時のアクション
  def update
    # post = Post.find(params[:id])   ← リファクタリング
    # 変数 post を @post に書き換えるのを忘れずに！
    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit
    end
  end
  
  # --- ここから追加 ---
  
  def destroy
    # 1. 消したいデータをIDで探す
    # post = Post.find(params[:id])   ← リファクタリング
    
    # 2. 削除する（Rubyの destroyメソッド）
    @post.destroy
    
    # 3. トップページに戻る
    redirect_to root_path, status: :see_other
    # ※ status: :see_other は、Rails 7（Turbo）で削除後にきれいにリダイレクトさせるためのおまじない
  end
  
  # --- ここまで ---

  private # ここから下は「このクラスの中でしか使えない」という意味（Ruby基礎！）

  # ストロングパラメーター（セキュリティ）
  # フォームから送られてきたデータの中から、content だけを許可する
  def post_params
    params.require(:post).permit(:content)
  end

  # IDからデータを1つ探してきて、インスタンス変数 @post に入れるメソッド
  def set_post
    @post = Post.find(params[:id])
  end
end