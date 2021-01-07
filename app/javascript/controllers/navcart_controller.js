import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "cartcount", "carttotalprice"]
 
  update(e) {
    e.preventDefault()
    const {count, total_price} = e.detail
    this.cartcountTarget.innerText = `${count}`
    this.carttotalpriceTarget.innerText = `${total_price}`
  }
}
