class CommentsController < ApplicationController
  def create
    # 1. どの投稿へのコメントかを探す（URLの post_id から）
    post = Post.find(params[:post_id])
    
    # 2. その投稿に紐付いたコメントを作成する
    # post.comments.build で「その投稿用のコメント」の準備ができる
    comment = post.comments.build(comment_params)
    
    if comment.save
      redirect_to post_path(post), notice: "コメントしました"
    else
      redirect_to post_path(post), alert: "コメントに失敗しました"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end