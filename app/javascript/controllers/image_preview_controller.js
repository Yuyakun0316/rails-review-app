import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // ターゲットの定義
  static targets = [ "input", "output" ]

  // ファイルが選択されたら動くメソッド
  preview() {
    // 1. 選択されたファイルを取得
    const file = this.inputTarget.files[0]
    
    // ファイルがある場合のみ処理
    if (file) {
      // 2. ファイル読み込み用のリーダーを作る
      const reader = new FileReader()

      // 3. 読み込み完了した時の処理（画像をセットする）
      reader.onload = (e) => {
        this.outputTarget.src = e.target.result
        this.outputTarget.classList.remove("hidden") // hiddenを消して表示させる
      }

      // 4. 読み込み開始！
      reader.readAsDataURL(file)
    } else {
      // ファイル選択がキャンセルされたら画像も消す
      this.outputTarget.src = ""
      this.outputTarget.classList.add("hidden")
    }
  }
}