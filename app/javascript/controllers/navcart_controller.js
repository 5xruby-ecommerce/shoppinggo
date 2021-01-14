import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "cartcount", "carttotalprice"]
 
  update(e) {
    e.preventDefault()
    const {count, cart_total} = e.detail
    this.cartcountTarget.innerText = `${count}`
    this.carttotalpriceTarget.innerText = `${cart_total}`
  }
}
