import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "postalCode", "address", "error" ]

  // 検索ボタンが押されたら動く
  search() {
    // 1. 入力された郵便番号を取得
    const code = this.postalCodeTarget.value
    
    // 2. 外部APIのURLを作成（zipcloudという無料サービス）
    const url = `https://zipcloud.ibsnet.co.jp/api/search?zipcode=${code}`

    // 3. fetchでデータを取ってくる
    fetch(url)
      .then(response => response.json()) // 結果をJSONとして読み込む
      .then(data => {
        if (data.results) {
          // 成功！住所を取り出してセットする
          const result = data.results[0]
          const fullAddress = `${result.address1}${result.address2}${result.address3}`
          
          this.addressTarget.value = fullAddress
          this.errorTarget.textContent = "" // エラーメッセージを消す
        } else {
          // 失敗（郵便番号が存在しないなど）
          this.errorTarget.textContent = "住所が見つかりませんでした"
          this.addressTarget.value = ""
        }
      })
      .catch(() => {
        this.errorTarget.textContent = "通信エラーが発生しました"
      })
  }
}