# frozen_string_literal: true

class PostsController < ApplicationController
  # index と show 以外のアクション（new, create, edit...）は、ログイン必須にする
  before_action :authenticate_user!, except: %i[index show]
  # アクションが動く「前（before）」に、set_postメソッドを実行せよ！という命令
  # only: [...] で、実行したいアクションだけを指定します
  before_action :set_post, only: %i[edit update destroy show]

  def index
    # 新しい投稿を作るための「空っぽのインスタンス」を用意
    # フォーム（form_with）で使うために必要！
    @post = Post.new
    # includes(:comments) を追加！
    # これで「投稿」を取るときに「コメント」も一緒に取得してメモリに載せてくれる
    # 変更前
    # @posts = Post.all.includes(:user)

    # 変更後： .page(params[:page]).per(5) を追加
    # 意味：ページ番号を受け取り、1ページあたり5件だけ表示する
    # @posts = Post.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
    # with_attached_image を追加！
    # これで「画像データ」も一緒にまとめて取ってきてくれます（N+1対策）
    # @posts = Post.all.includes(:user).with_attached_image.order(created_at: :desc).page(params[:page]).per(5)

    # 変更後：Ransackを使う形にする
    # 1. 検索オブジェクトを作る（params[:q] に検索ワードが入ってくる）
    @q = Post.ransack(params[:q])
    
    # 2. 検索結果を取得する（result）
    # distinct: true は重複を防ぐおまじない
    @posts = @q.result(distinct: true).includes(:user).with_attached_image.order(created_at: :desc).page(params[:page]).per(5)
  end

  # showアクションを追加（中身は空でOK。before_actionがやってくれるから）
  def show; end

  # 編集画面を表示するアクション
  def edit
    # URLの「/posts/1/edit」の「1」を params[:id] で受け取る
    # find(番号) で、そのIDのデータをデータベースから探してくる
    # @post = Post.find(params[:id])   ← リファクタリング
  end

  # フォームから送られてきた時のアクション
  def create
    # 変更前：誰のか分からない状態で保存
    # Post.create(post_params)

    # 変更後：ログイン中のユーザーに紐付けて保存する！
    # build は new と同じ意味ですが、アソシエーションを使う時はよく build を使います
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to root_path, notice: '投稿しました！'
    else
      # 保存失敗したら、一覧画面に戻す（変数を再取得する必要あり）
      @posts = Post.includes(:user) # N+1対策で :user も追加しておくとGood
      render :index, status: :unprocessable_content
    end
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
    # :image を追加
    params.require(:post).permit(:content, :image)
  end

  # IDからデータを1つ探してきて、インスタンス変数 @post に入れるメソッド
  def set_post
    @post = Post.find(params[:id])
  end
end
