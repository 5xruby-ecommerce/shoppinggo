import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["shoptotal"]
  update(e) {
    e.preventDefault()
    const {count, total_price, shoptotal} = e.detail
    this.shoptotalTarget.innerText = `${shoptotal}`
  }
  
}
