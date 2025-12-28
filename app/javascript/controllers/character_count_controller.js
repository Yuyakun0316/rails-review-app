import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-count"
export default class extends Controller {
  // HTMLでつけた target の名前をここに定義する
  static targets = [ "input", "output" ]

  // 画面が表示された時に一度だけ動くメソッド
  connect() {
    console.log("文字数カウンターが接続されました！")
    this.count() // 初期状態でもカウントを実行しておく
  }

  // 文字を打つたびに実行されるメソッド
  count() {
    // 1. 入力された文字を取得
    const content = this.inputTarget.value
    
    // 2. 文字数を計算
    const length = content.length
    
    // 3. 残り文字数を計算（例: 140文字制限）
    const remaining = 140 - length
    
    // 4. 画面（outputTarget）の数字を書き換える
    this.outputTarget.textContent = remaining

    // おまけ：文字数オーバーしたら赤くする
    if (remaining < 0) {
      this.outputTarget.classList.add("text-red-500")
    } else {
      this.outputTarget.classList.remove("text-red-500")
    }
  }
}