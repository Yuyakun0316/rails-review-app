# Rails復習アプリ

## 学んだこと（ルーティングとMVCの基礎）
Railsでページが表示される仕組みは以下の通り。

1. **Routes (`routes.rb`)**: ブラウザからのリクエスト（URL）を受け取り、適切なコントローラーに振り分ける「案内役」。
2. **Controller (`posts_controller.rb`)**: 案内されたリクエストを受け取り、処理を行う「司令塔」。
3. **View (`index.html.erb`)**: 最終的にユーザーに見せるHTMLを作る「画面担当」。

今回は `root to: 'posts#index'` を設定することで、トップページへのアクセスをPostsコントローラーへ繋いだ。