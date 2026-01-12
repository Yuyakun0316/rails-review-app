# frozen_string_literal: true

class PostsController < ApplicationController
  # index と show 以外のアクション（new, create, edit...）は、ログイン必須にする
  before_action :authenticate_user!, except: %i[index show]
  # アクションが動く「前（before）」に、set_postメソッドを実行せよ！という命令
  # only: [...] で、実行したいアクションだけを指定します
  before_action :set_post, only: %i[edit update destroy show]

  def index
    @post = Post.new

    # 1. 検索オブジェクト（Ransack）の準備
    @q = Post.ransack(params[:q])

    # 2. ベースとなる投稿データを準備（検索結果 + N+1対策 + 並び順）
    # ※ここではまだ「.page」などのページネーションはしません！変数 posts に一時保存します。
    # 変更前
    # posts = @q.result(distinct: true).includes(:user).with_attached_image.order(created_at: :desc)

    # 1. includes(:likes) を追加して「いいね」を読み込む
    # 2. user を includes する時に、さらにその先の avatar_attachment も読み込む（ネスト）
    posts = @q.result(distinct: true).published.includes(user: { avatar_attachment: :blob }).with_attached_image.order(created_at: :desc)
    # 3. タブの選択状況によってデータを絞り込む
    @posts = if params[:type] == 'following' && user_signed_in?
               # 「フォロー中」タブが選ばれた場合
               # current_user.following_ids で自分がフォローしている人のID一覧を取得し、
               # モデルで定義した scope :by_users を使って絞り込みます
               posts.by_users(current_user.following_ids).page(params[:page]).per(5)
             else
               # 「すべて」タブ、またはログインしていない場合
               # 絞り込みをせずにそのままページネーションします
               posts.page(params[:page]).per(5)
             end
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
      # 保存成功時：トップページへリダイレクト
      redirect_to root_path, notice: "投稿しました！"
    else
      # 保存失敗時（バリデーションエラーなど）：
      # render :index だと @q がなくてエラーになるので、ここも redirect_to にしてしまいます。
      # （エラーメッセージを表示したい場合は flash[:alert] を使います）
      redirect_to root_path, alert: "投稿に失敗しました。内容を入力してください。"
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
    # :status を追加
    params.require(:post).permit(:content, :image, :status)
  end

  # IDからデータを1つ探してきて、インスタンス変数 @post に入れるメソッド
  def set_post
    @post = Post.find(params[:id])
  end
end
